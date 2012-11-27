#lang plai

(require "symbolic-differentiation.rkt")

(command-line
 #:args (input)
 (do-all (read (open-input-string input))))