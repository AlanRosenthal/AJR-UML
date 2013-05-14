
// Scala runs on the JVM with strong Java interoperability, so
// if you know Java it helps to think of Scala in terms of what
// the equivilent Java code would be.


// The "object" keyword creates a singleton object with all static
// methods.
object ScalaBasics {
  // Implement fib(n) both iteratively and recursively.
  def fibI(n: Int) = 5
  
  def fibR(n: Int):Int = 5
  
  // Square each item in the array, in place.
  def squareArrayInPlace(xs: Array[Int]) = Array(5)
  
  // Return a new list with each item squared.
  def squareList(xs: List[Int]) = List(5)
  
  // Map from Fold
  def map(fn: Any, xs: List[Int]) = List(5)
}
  
// Define Duck, Dog, and Mouse classes that inherit from Animal.
// Ducks should Quack, Dogs should Woof, and Marmots should inherit
// Squeek.

// Each animal class should include a trait "Weighable" that adds a
// "weight" method which returns the length of that animal's name.

class Animal(name: String) {
  def speak() {
    println(name + ": Squeek!")
  }
}

// Define a Matrix class that lets you do the following:
//  > var m4x4 = new Matrix(4, 4)
//  > m4x4(1, 2) = 3
//  > m4x4
//  "Matrix(4,4):
//  0 0 0 0
//  0 0 3 0
//  0 0 0 0
//  0 0 0 0
//  "
//  > m4x4.transpose()
//  > m4x4
//  "Matrix(4,4):
//  0 0 0 0
//  0 0 0 0
//  0 3 0 0
//  0 0 0 0
//  "
//  > m4x4(2, 1)
//  3
