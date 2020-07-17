import UIKit

var optionalString: String? = "Hello"

print(optionalString == nil)

//var optionalName:String? = "John"

var optionalName:String? = nil
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
}

print(greeting)
print(optionalString!)

let nickname: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi, \(nickname ?? fullName)!"

print(informalGreeting)

let vegetable = "red pepper"
// Pattern maching "switch"
switch vegetable {
case "celery":
    print("we have 1 \(vegetable)")
    //case "red pepper":
//    print("we have 2 \(vegetable)")
case let pepper where pepper.hasPrefix("red"):
    print("Is it a red pepper?")
default:
    print("no vegetable")
}

let peopleDict = ["Pipi": 12, "Peter":13, "Ala":15]
for person in peopleDict {
    print("person is \(person.key) years \(person.value) old")
}

for (name, age) in peopleDict {
    print("person is \(name) years \(age) old")
}

var i = 2
while (i > 0) {
    print("1. i = \(i)")
    i -= 1
}

i = 2
repeat {
    print("2. i = \(i)")
    i -= 1
} while (i > 0)


for i in 0 ..< 4 {
    print(String(format: "number: %d will never be = 4", i))
}

for i in 0 ... 4 {
    print(String(format: "number: %d will be = 4", i))
}


func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)!"
}

let greetStr = greet(person: "Bob2", day: "Monday")
print(greetStr)

func greet2(_ person: String, day: String) -> String {
    return "Hi \(person), today is \(day)!"
}

let greet2Str = greet2("Bob3", day: "Friday")
let greet3Str = greet2("Bob4", day: "Friday")

print(greet2Str)
print(greet3Str)

func makeTuple(_ string: String, _ integer: Int) -> (String, Int) {
    return (string, integer)
}

print("my tuple: ", makeTuple("alabala", 2))


func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        }
        else if score < min {
            min = score
        }
        sum += score
    }
    
    return (min, max, sum)
}

let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print("sum -> ", statistics.sum)
print("sum -> ", statistics.2)
print("max -> ", statistics.1)
print("min -> ", statistics.0)

func return156() -> Int {
    var y = 10
    func addFive() {
        y += 5
    }
    
    func multiplyByTen() {
        y *= 10
    }
    
    func addToAnIncrementOne(_ int: Int) -> Int {
        return y + int + 1;
    }
    
    addFive()
    multiplyByTen()
    
    return addToAnIncrementOne(5)
}

print("Result ", return156())

func makeIncrementer(_ incremetee: Int = 1) -> ((Int) -> Int) {
    func incrementer(number: Int) -> Int {
        return number + incremetee
    }
    
    return incrementer
}

let incrementer5 = makeIncrementer(5)
let incrementer = makeIncrementer()

print("7 -> ", incrementer5(7))
print("9 -> ", incrementer(9))


func performOperation(_ list: [Int], operation: (Int) -> Int){
    var tempList = [Int]()
    for l in list {
        tempList.append(operation(l))
    }
    
    print(tempList)
}


performOperation([1, 2, 3, 4], operation: { (number: Int) -> Int in return number + 1 })

performOperation([1, 2, 3, 4], operation: { (number: Int) -> Int in return number + 1 })

func operation(int: Int) -> Int {
    return int + 5
}

performOperation([1, 2, 3, 4], operation: operation)

let numbers = [1, 2, 3, 4, 5, 6, 7]
let evenNumbers = numbers.map({(number: Int) -> Int in
    if number % 2 == 0 {
        return 0
    }
    return number
})

print(numbers)
print(evenNumbers)

class Shape {
    
    struct Coordinates {
        var x: Int
        var y: Int
    }
    
    var coordinates: Coordinates
    
    let origin: Coordinates
    
    init(_ x: Int, _ y: Int) {
        self.origin = Coordinates(x: x, y: y)
        self.coordinates = self.origin
        
        print("Initializing a Shape at location from origin: ", distance())
        print("Initializing a Shape at: \(self.origin.x), \(self.origin.y)")
    }
    
    deinit {
        print("Deinitializing a Shape at location from origin: ", distance())
        print("Deinitialized a Shape at: \(self.origin.x), \(self.origin.y)")
    }
    
    func distance() -> Float {
        let x = Float(self.coordinates.x)
        let y = Float(self.coordinates.y)
        
        return sqrt(pow(x, 2.0) + pow(y, 2.0))
    }
    
}





class Square : Shape {
    
    let width: Float
    let height: Float
    
    init(originX: Int, originY: Int, endX: Int, endY: Int) {
        self.width = Float(endX - originX)
        self.height = Float(endY - originY)
        
        super.init(originX, originY)
        
        print("Initialized a Square with Weight: \(self.width), Height: \(self.height)")
        print("Initialized a Square at: \(self.origin.x), \(self.origin.y)")
    }
    
    deinit {
        print("Deinitialized a Square at: \(self.origin.x), \(self.origin.y)")
    }
    
}

let testShapes = {() in
    print("==== Shape 1:")
    
    var shape = Shape(1, 1)
    
    print(shape)
    
    print("----> location from origin: ", shape.distance())
    
    print("==== Shape 1:")
    
    shape = Square(originX: 2, originY: 2, endX: 12, endY: 12)
    
    print(shape)
    
    print("----> location from origin: ", shape.distance())
}

testShapes()


class Triangle : Shape {
    typealias Point = Coordinates
    
    let p1: Point
    let p2: Point
    let p3: Point
    
    var privateName: String? = nil
    var privateFullname: String? = nil
    var privateData: String
    
    var name: String {
        get {
            print("getting the name")
            print("-----> 0", self.privateName as Any)
            guard let name = self.privateName, !name.isEmpty else {
                print("-----> 1", self.privateName as Any)
                return String(format: "Triangle with origin at %f, %f", self.origin.x, self.origin.y)
            }
            print("-----> 2", self.privateName as Any)
            return name
        }
        set {
            print("setting the name")
            print("-----> 3", self.privateName as Any)
            self.privateName = newValue
            print("-----> 4: ", self.privateName as Any)
        }
    }
    
    var fullName: String {
        get {
            guard let name = self.privateFullname, !name.isEmpty else {
                return String(format: "Triangle with origin at %f, %f", self.origin.x, self.origin.y)
            }
            return name
        }
        set {
            self.privateFullname = newValue
        }
    }
    
    var myPrivateData: String {
        willSet {
            print(">>> WILL SET")
            self.privateData = self.fullName
        }
        didSet {
            print(">>> DID SET")
        }
    }
    
    init(p1: Point, p2: Point, p3: Point) {
        
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
        
        self.privateData = "privateData - not set yet"
        self.myPrivateData = "myPrivateData - not set yet"
        
        super.init(p1.x, p1.y)
    }
}

let triangle = Triangle(p1: Triangle.Point(x: 1, y: 1), p2: Triangle.Point(x: 2, y: 2), p3: Triangle.Point(x: 1, y: 2))
print(">>> triangle: ", triangle.name)
triangle.name = "MioName is triangle"
print(">>> triangle: ", triangle.name)

print(">>> triangle fn: ", triangle.fullName)
triangle.fullName = "MioName is a triangle's fullName property"
print(">>> triangle fn: ", triangle.fullName)

print("===> ", triangle.myPrivateData)
triangle.myPrivateData = "Abracadabra is my private data"
print("===> ", triangle.myPrivateData)

// Enum with type
enum Color: Int8 {
    case White = 1 // raw value
    case Black, Green, Yellow
    
    func name(_ color: Color) -> String {
        switch (color) {
        case Color.White:
            return "white"
        case Color.Black:
            return "black"
        case Color.Green:
            return "green"
        default:
            return "any other color"
        }
    }
    
    static func name(_ color: Color) -> String {
        switch (color) {
        case Color.White:
            return "white"
        case Color.Black:
            return "black"
        default:
            return "any other color"
        }
        
    }
}

let color = Color.Green
print("Color color           : ", color)
print("Color 1 name static   : ", Color.name(color))
print("Color 2 name instance : ", color.name(color))
print("Color rawValue        : ", color.rawValue)


enum ColorName : String {
    case White = "white"
    case Blue
    case Black
}

var colorName = ColorName.Black
print("ColorName = ", colorName)
print("ColorName = ", colorName.rawValue)
colorName = ColorName.White
print("ColorName = ", colorName)
print("ColorName = ", colorName.rawValue)


enum ColName {
    case Green,
    Black,
    Blue
}
let colName = ColName.Black
print("ColName = ", colName)
//print("ColName = ", colName.rawValue) <-- No rawValue is available

if let cv = ColorName.init(rawValue: "white") {
    print("cv: ", cv)
    print("cv: ", cv.rawValue)
}
else {
    print("!!!! Enum from raw value failure!")
}

if let cv = ColorName.init(rawValue: "green") {
    print("cv: ", cv)
    print("cv: ", cv.rawValue)
}
else {
    print("!!!! Enum from raw value failure!")
}

enum Suit {
    case spades, hearts, diamonds, clubs
    
    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "<spades>"
        case .hearts:
            return "<hearts>"
        case .diamonds:
            return "<diamonds>"
        case .clubs:
            return "<clubs>"
        }
    }
    
    func color() -> String {
        switch self {
        case .spades, .clubs:
            return "red"
        case .hearts, .diamonds:
            return "black"
        }
    }
    
    static func color(color: Suit) -> String {
        switch color {
        case .spades, .clubs:
            return "red"
        case .hearts, .diamonds:
            return "black"
        }
    }
}

let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()
print("----> hearts           : ", hearts)
print("----> heartsDescription: ", heartsDescription)

print("====> color i: ", hearts.color())
print("====> color s: ", Suit.color(hearts)) // Why prints function?
let colorSuit = Suit.color(hearts) // Why is function?
print("====> color s: ", colorSuit) // same

class Engine
{
    var hp: Int
    var maxSpeed: Int
    
    init(_ hp: Int, _ maxSpeed: Int) {
        self.hp = hp
        self.maxSpeed = maxSpeed
    }
}

//enum Payload {
//    case book(String, String)
//    case clock(String, Int)
//    case car(String, Engine)
//}
//
//func report(payload: Payload) {
//    switch payload {
//    case .book(title, author):
//        print("Book by \(author): \(title)")
//
//    case .clock(name, time):
//        print("Clock by \(name): \(time)")
//
//    case .car(brand, engine):
//        print("Car by \(brand): \(engine.hp) hp at \(engine.maxSpeed) km/h")
//    }
//}


struct TheStruct {
    var i = 0
}

class TheClass {
    var i = 0
}


var s1 = TheStruct()
var s2 = s1
s1.i = 1
print("s1 by value - \(s1.i) in \(s1)")
print("s2 by value- \(s2.i) in \(s2)")


var c1 = TheClass()
var c2 = c1
c1.i = 1
print("c1 by reference - \(c1.i) in \(c1)")
print("c2 by reference - \(c2.i) in \(c2)")

struct GeometricCoordinates {
    var x : Double
    var y : Double
}

protocol GeometricShape {
    var origin: GeometricCoordinates {
        get
        set
    }
    
    func translateTo(_ coordinates: GeometricCoordinates)
}


class GeometricTriangle : GeometricShape {
    
    var origin:GeometricCoordinates
    
    init(_ origin: GeometricCoordinates) {
        self.origin = origin
    }
    
    func translateTo(_ coordinates: GeometricCoordinates) {
        self.origin = coordinates
    }
    
}

protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
    func test()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }
    
    func test() {
        print("Testing ---- : \(self)")
    }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
    
    func test() {
        print("Testing ----- : \(self)")
    }
}

var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription
print("---> \(bDescription)")
b.test()

extension Double: ExampleProtocol {
    
    var simpleDescription: String {
        return "Simple Number \(self)"
    }
    
    mutating func adjust() {
        self *= 42
    }
    
    func test() {
        print("Testing: \(self)")
    }
}

var variable: Double = 5

variable.adjust()
variable.test()

let constant: Double = 4
constant.test()

print(2.0.simpleDescription)

extension Double {
    var absoluteValue: Double {
        get {
            return self < 0 ? -self : self
        }
    }
}

print("Absolute value: ", 2.0.absoluteValue)
print("Absolute value: ", -2.0.absoluteValue)

var abs = Double(2.0).absoluteValue
print("abs \(abs)")
abs = Double(-2.0).absoluteValue
print("abs \(abs)")

let x = Int8.min
// x == -128
//let y = abs(x)
// Overflow error

extension Int {
    var absoluteValue: Int {
        get {
            return self < 0 ? -self : self
        }
    }
}


print("Absolute value: ", 2.absoluteValue)
print("Absolute value: ", -2.absoluteValue)

var abs2: Int = 2
print("abs2 \(abs2.absoluteValue)")
abs2 = -2
print("abs2 \(abs2.absoluteValue)")

//extension Int8 {
//    var absoluteValue: Int8 {
//        get {
//            return abs(self)
//        }
//    }
//}

enum GenericLifeError: Error {
    case MyFault
    case Mistake
    case Dead
    case GameOver
}

func getLife(_ life: String) throws -> String {
    if life == "No life at all" {
        throw GenericLifeError.Dead
    }
    
    return "More life added"
}

do {
    let life = try getLife("No life at all")
    print(life)
}
catch {
    print("Got error", error)
}

// No error here
do {
    let life = try getLife("2")
    print(life)
}
catch GenericLifeError.Dead {
    print("caught death")
}
catch let errorOfLife as GenericLifeError {
    print("Generic error \(errorOfLife)")
}
catch {
    print("Got error", error)
}

// Error
do {
    let life = try getLife("No life at all")
    print(life)
}
catch GenericLifeError.Dead {
    print("caught death")
}
catch let errorOfLife as GenericLifeError {
    print("Generic error \(errorOfLife)")
}
catch {
    print("Got error", error)
}

print("testing ?try - begin")
if let life = try? getLife("No life at all") {
    print("all is fine: \(life)")
}
else
{
    print("we failed the test")
}
print("testing ?try - end")

print("testing ?try - begin - no error")
if let life = try? getLife("No life at all2342") {
    print("all is fine: \(life)")
}
else
{
    print("we failed the test")
}
print("testing ?try - end")

var isWorking = false
func machineDo(_ test: Bool) -> Bool {
    defer {
        isWorking = false
    }
    isWorking = test
    
    if (isWorking) {
        return true
    }
    else {
        return false
    }
}

let m = machineDo(true)
print(m)
print(isWorking)

func addMore<Type>(_ arr: [Type], repeating item: Type, count: Int) -> [Type] {
    var result = arr
    for _ in 0 ..< count {
        result.append(item)
    }
    
    return result
}

let arr = [1, 2, 3]
let arrR = addMore(arr, repeating: 0, count: 5)
print(arr)
print(arrR)

// Reimplement the Swift standard library's optional type
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}

var possibleInteger: OptionalValue<Int> = .none
print(possibleInteger)

possibleInteger = .some(100)
print(possibleInteger)

func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    
    return false
}

var isB = anyCommonElements([1, 2, 3], [3])
print(isB)
isB = anyCommonElements(["a", "b", "c"], ["c"])
print(isB)
