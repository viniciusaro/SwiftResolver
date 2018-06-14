import Foundation

final class SomeDependency {}
final class SomeType {
    let dependency: SomeDependency
    init(dependency: SomeDependency) {
        self.dependency = dependency
    }
}

final class Child {}

final class Father {
    let child: Child
    init(child: Child) {
        self.child = child
    }
}

final class Mother {
    let child: Child
    init(child: Child) {
        self.child = child
    }
}

final class Family {
    let father: Father
    let mother: Mother
    let child: Child
    init(father: Father, mother: Mother, child: Child) {
        self.father = father
        self.mother = mother
        self.child = child
    }
}

final class House {
    let family: Family
    let owner: Father

    init(owner: Father, family: Family) {
        self.family = family
        self.owner = owner
    }
}

final class Street {
    let house1: House
    let house2: House
    let house3: House
    let house4: House
    let house5: House

    init(house1: House,
         house2: House,
         house3: House,
         house4: House,
         house5: House) {
        self.house1 = house1
        self.house2 = house2
        self.house3 = house3
        self.house4 = house4
        self.house5 = house5
    }
}

protocol Animal {
    func makeSound()
}

final class Cat: Animal {
    func makeSound() {
        print("Gato")
    }
}

final class Dog: Animal {
    var name: String = ""
    func makeSound() {
        print("Cachoro")
    }

    static func with(name: String) -> Dog {
        let dog = Dog()
        dog.name = name
        return dog
    }
}

enum Dogs: String {
    case teo
    case bob
}
