import SwiftResolver

protocol Animal {
    func makeSound()
}

final class Cat: Animal {
    func makeSound() {
        print("Gato")
    }
}

final class Dog: Animal {
    func makeSound() {
        print("Cachoro")
    }
}

let container = Container()
container.register { Cat() }.as(Animal.self)

let animal: Animal = container.resolve(Cat.self)
animal.makeSound()

//final class A {
//    let animal: Animal
//    init(animal: Animal) {
//        self.animal = animal
//    }
//}

