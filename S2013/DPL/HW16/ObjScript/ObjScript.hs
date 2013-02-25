{-# LANGUAGE DeriveDataTypeable, TypeSynonymInstances, FlexibleInstances #-}
module Main where

import System.Environment (getArgs)
import System.Console.Readline

import qualified Control.Exception as E
import Control.DeepSeq (deepseq)
import Data.Typeable

import qualified Data.Map as M
import Data.Map (Map)
import Data.Maybe
import Data.List (foldl', mapAccumL)
import Utils (split, join)

import ParseTree
import Parser (parseString)

data RuntimeError = RuntimeError String
  deriving(Show, Typeable)

instance E.Exception RuntimeError

carp text = E.throw $ RuntimeError $ text

---- Our Object Type ----

data Object = Object (Map String Object) PrData

instance Eq Object where
  (Object aa PrNone) == (Object bb PrNone) = 
          M.delete "proto" aa == M.delete "proto" bb
  (Object _ aa) == (Object _ bb) = aa == bb

                   -- ctx       self      args        (st', vv)
type BuiltinMethod = (Object -> Object -> [Object] -> (Object, Object))

instance Eq BuiltinMethod where
  aa == bb = True

-- Primitive Types
data PrData = PrNone
            | PrNil
            | PrNumber Int
            | PrString String
            | PrList [Object]
                  -- params   body
            | PrFun [String] ParseTree
            | PrBuiltin BuiltinMethod
  deriving (Eq)

instance Show Object where
  show (Object _ PrNil)         = "Nil"
  show (Object _ (PrNumber nn)) = show nn
  show (Object _ (PrString ss)) = "\"" ++ ss ++ "\""
  show (Object _ (PrList xs))   = "[" ++ join ", " (map show xs) ++ "]"
  show (Object _ (PrFun _ _))   = "[Function]"
  show (Object _ (PrBuiltin _)) = "[Builtin]"
  show (Object mm PrNone)       =  
      "{ " ++ (join ", " $ map (showEntry mm) (M.keys mm)) ++ " }"
      where showEntry mm kk = kk ++ ": " ++ (show.fromJust) (M.lookup kk mm)

-- Common object constructors
nilObject        = Object M.empty PrNil
builtinMethod fn = Object M.empty (PrBuiltin fn)

numberObject ctx nn = Object (M.fromList props) (PrNumber nn)
  where props = [("proto", getName ctx "Number")]

stringObject ctx ss = Object (M.fromList props) (PrString ss)
  where props = [("proto", getName ctx "String")]

listObject   ctx xs =  Object (M.fromList props) (PrList xs)
  where props = [("proto", getName ctx "List")]

---- Builtin Methods ----

-- Object Methods

--   TODO:
--      osClone_ is wrong.

osClone_ obj = obj
osClone ctx self [] = (ctx, osClone_ self)
osClone _ _ _ = carp $ "Call clone as a method on the object to clone"

-- List Methods
osCons ctx (Object mm (PrList xs)) [x] = (ctx, Object mm (PrList $ x:xs))
osCons _ _ _ = carp $ "Cons is a List method that takes one argument"

osHead ctx (Object mm (PrList (x:xs))) [] = (ctx, x)
osHead _ _ _ = carp $ "Head is a List method that takes no arguments"

osTail ctx (Object mm (PrList (x:xs))) [] = (ctx, Object mm (PrList xs))
osTail _ _ _ = carp $ "Tail is a List method that takes no arguments"

osLength ctx (Object mm (PrList xs)) [] = (ctx, numberObject ctx $ length xs)
osLength _ _ _ = carp $ "Length is a List method that takes no arguments"

-- Number <=> String Conversion Methods
osAtoi ctx (Object mm (PrString ss)) [] = (ctx, numberObject ctx $ read ss)
osAtoi _ _ _ = carp $ "Atoi is a String method that takes no arguments"

osItoa ctx (Object mm (PrNumber nn)) [] = (ctx, stringObject ctx $ show nn)
osItoa _ _ _ = carp $ "Itoa is a Number method that takes no arguments"

---- Starting Environment ----

-- TODO:
--    objectProto is wrong

objectProto = Object M.empty PrNone

listProto   = Object (M.fromList props) (PrList [])
  where props = [("proto", objectProto), ("cons", builtinMethod osCons),
          ("head",  builtinMethod osHead), ("tail", builtinMethod osTail),
          ("length", builtinMethod osLength)]

numberProto = Object (M.fromList props) (PrNumber 0)
  where props = [("proto", objectProto), ("asString", builtinMethod osItoa)] 

stringProto = Object (M.fromList props) (PrString "")
  where props = [("proto", objectProto), ("asNumber", builtinMethod osAtoi)]

emptyLobby = Object (M.fromList props) PrNone
  where props = [("proto", objectProto), ("Object", objectProto)]

-- Common object accessors
isNil (Object _ PrNil) = True
isNil _                = False

objectType (Object _ PrNil)        = "Nil"
objectType (Object _ (PrNumber _)) = "Number"
objectType (Object _ (PrString _)) = "String"
objectType (Object _ (PrList _))   = "List"
objectType (Object _ (PrFun _ _))  = "Fun"
objectType (Object _ (PrBuiltin _)) = "Builtin"
objectType obj = show $ getSlot obj "type"

prGetInt (Object _ (PrNumber nn)) = nn
prGetInt obj = carp $ "Tried to treat " ++ objectType obj ++ " as Int"

asNumber st obj@(Object _ (PrNumber _)) = (st, obj)
asNumber st obj =
  let fun = getName obj "asNumber" in
  if isNil fun
    then (st, numberObject st (prGetInt obj))
    else callFun fun st obj []

asString st obj@(Object _ (PrString _)) = (st, obj)
asString st obj =
  let fun = getName obj "asString" in
  if isNil fun
    then (st, stringObject st (show obj))
    else callFun fun st obj []

-- TODO:
--   callFun is wrong.

callFun (Object _ (PrFun params code)) st self args = (st', vv)
  where (st', vv)       = eval st code
callFun (Object _ (PrBuiltin bb)) st self args = bb st self args
callFun obj _ _ _ = carp $ "Type " ++ objectType obj ++ " isn't a function"

-- Object slot access
hasSlot :: Object -> String -> Bool
hasSlot (Object mm dd) kk    = M.member kk mm

getSlot :: Object -> String -> Maybe Object
getSlot (Object mm dd) kk    = M.lookup kk mm

setSlot :: Object -> String -> Object -> Object
setSlot (Object mm dd) kk vv = 
  if M.member kk mm 
    then Object (M.insert kk vv mm) dd
    else carp $ "No such slot in setSlot: " ++ kk

newSlot :: Object -> String -> Object -> Object
newSlot (Object mm dd) kk vv = Object (M.insert kk vv mm) dd

-- Get Slot from Object or Object Prototype
getSlotP obj name =
  let slot = getSlot obj name in
  if isJust slot
    then slot
    else case getSlot obj "proto" of
            Just proto -> getSlotP proto name
            Nothing    -> Nothing

-- Deep object slot access
hasSlotR :: Object -> [String] -> Bool
hasSlotR _ []       = error "Can't hasSlotR on slot []"
hasSlotR obj [name] = hasSlot obj name
hasSlotR obj (n:ns) = case getSlot obj n of
                        Just slot -> hasSlotR slot ns
                        Nothing   -> False

getSlotR :: Object -> [String] -> Maybe Object
getSlotR _ []       = error "Can't getSlotR on slot []"
getSlotR obj [name] = getSlotP obj name
getSlotR obj (n:ns) = getSlotP obj n >>= (\slot -> getSlotR slot ns)

setSlotR :: Object -> [String] -> Object -> Object
setSlotR _ [] _        = error "Can't setSlotR on slot []"
setSlotR obj [name] vv = setSlot obj name vv
setSlotR obj (n:ns) vv =
  if hasSlotR obj (n:ns)
    then setSlot obj n slot1
    else carp $ "No such slot in setSlotR: " ++ show (n:ns)
      where slot0 = fromJust $ getSlot obj n
            slot1 = setSlotR slot0 ns vv

newSlotR :: Object -> [String] -> Object -> Object
newSlotR _ [] _        = error "Can't newSlotR on slot []"
newSlotR obj [name] vv = newSlot obj name vv
newSlotR obj (n:ns) vv =
  if isJust $ getSlotR obj (init $ n:ns)
    then newSlot obj n slot1
    else carp $ "No such slot in newSlotR: " ++ show (obj, (n:ns))
      where slot0 = fromJust $ getSlotP obj n
            slot1 = newSlotR slot0 ns vv

-- Scope Resolution
newName :: Object -> String -> Object -> Object
newName ctx name vv = newSlotR ctx (split "." name) vv

setName :: Object -> String -> Object -> Object
setName ctx name vv = setSlotR ctx (split "." name) vv

getName :: Object -> String -> Object
getName ctx name =
  let names = split "." name in
  case getSlotR ctx names of
    Just vv -> vv
    Nothing -> carp $ "Lookup failed for name " ++ name

-- ########################
--
--      eval
--
-- ########################

eval :: Object -> ParseTree -> (Object, Object)

-- Literals
eval st (PtNum nn) = (st, numberObject st nn)
eval st (PtStr ss) = (st, stringObject st ss)

-- Variables
eval st (PtSymb nn) = (st, getName st nn)

-- Assignment
eval st (PtBop "=" (PtSymb nn) bb) = (setName st' nn vv, vv)
  where (st', vv) = eval st bb

eval st (PtBop ":=" (PtSymb nn) bb) = (newName st' nn vv, vv)
  where (st', vv) = eval st bb

-- Object Equality
eval st (PtBop "==" aa bb) = (st2, numberObject st vv)
  where (st1, aa') = eval st aa
        (st2, bb') = eval st1 bb
        vv         = if aa' == bb' then 1 else 0

eval st (PtBop "!=" aa bb) = (st2, numberObject st vv)
  where (st1, aa') = eval st aa
        (st2, bb') = eval st1 bb
        vv         = if aa' /= bb' then 1 else 0

-- Numeric Operators
eval st (PtBop name aa bb) = (st4, numberObject st4 vv)
  where (st1, aa1) = eval st aa
        (st2, aa2) = asNumber st1 aa1
        (st3, bb1) = eval st2 bb
        (st4, bb2) = asNumber st3 bb1
        (xx,  yy ) = (prGetInt aa2, prGetInt bb2)
        vv = case name of
            "*"  -> xx * yy
            "/"  -> xx `div` yy
            "%"  -> xx `mod` yy
            "+"  -> xx + yy
            "-"  -> xx - yy
            ">"  -> if xx > yy then 1 else 0
            "<"  -> if xx < yy then 1 else 0
            "<=" -> if xx <= yy then 1 else 0
            ">=" -> if xx >= yy then 1 else 0
            "||" -> if xx /= 0 || yy /= 0 then 1 else 0
            "&&" -> if xx /= 0 && yy /= 0 then 1 else 0
            _    -> carp $ "unknown operator: " ++ name

-- Composite Expressions
eval st (PtComp xs) =
  foldl' evalNext (st, nilObject) xs
  where evalNext (st', _) ee = eval st' ee

-- List
eval st (PtArr xs) = (st', listObject st $ reverse ys')
  where (st', ys')            = foldl' evalNext (st, []) xs
        evalNext (st1, ys) ee =
                  case eval st1 ee of
                    (st2, y) -> (st2, y : ys)

-- Functions
eval st (PtFun params code) = (st, fun)
  where fun = Object M.empty (PrFun params code)

eval st (PtCall (PtSymb funName) args) = callFun fun st' self args'
  where names        = split "." funName
        selfName     = join "." $ init names
        fun          = getName st funName
        self         = if length selfName == 0 then st else getName st selfName
        (st', args') = mapAccumL eval st args

-- Control Flow
eval st (PtIf cond case0 case1) = 
  let (st', condVal) = eval st cond in
  if prGetInt condVal /= 0
    then eval st' case0
    else eval st' case1

eval st (PtFor var gen body) = (st, nilObject)

-- ########################
--
--      REPL and main
--
-- ########################

readLoop :: String -> (ParseTree -> a -> IO a) -> a -> IO a
readLoop prompt fn st = 
  do maybeLine <- readline prompt
     case maybeLine of
       Just line -> do code <- safeParse line 
                       st'  <- fn code st
                       readLoop prompt fn st'
       Nothing   -> return st

safeParse :: String -> IO ParseTree
safeParse code =
  case parseString code of
    Left  err  -> do
      putStrLn ("Parse Error:\n" ++ show err)
      return $ PtComp [] 
    Right tree -> do
      return tree

safeEvalPrint :: ParseTree -> Object -> IO Object
safeEvalPrint code st = do
  let (st', vv) = eval st code
  result <- E.try $ print vv >> E.evaluate st'
  case result of
    Left (RuntimeError msg) -> do
      putStrLn $ "Runtime Error: " ++ msg
      return st
    Right st'' -> return st''

main = do
  args <- getArgs
  code <- if length args >= 1
            then readFile (args !! 0)
            else return ""
  inpt <- if length args >= 2
            then readFile (args !! 1)
            else return ""
  tree <- safeParse code
  st0  <- safeEvalPrint tree emptyLobby
  readLoop "Obj> " safeEvalPrint (newSlot st0 "input" (stringObject st0 inpt))
