import Quick
import Nimble
@testable import SwiftResolver

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

class ContainerTests: QuickSpec {
    override func spec() {
        describe("when deallocating") {
            it("should not create reference cycles") {
                var container: Container! = Container()
                weak var weakContainer: Container? = container
                container.register(scope: .instance, Object0.init)
                container.register(scope: .shared, Object1.init)
                container.register(scope: .singleton, Object2.init)
                _ = container.resolve() as Object0
                _ = container.resolve() as Object1
                _ = container.resolve() as Object2
                container = nil
                expect(weakContainer).to(beNil())
            }
        }
        describe("when registering multiple instances of the same type") {
            var container: Container!
            beforeEach {
                container = Container()
            }
            it("should resolve generic type") {
                container.register(Dog.init).as(Animal.self)
                let animal: Animal = container.resolve()
                expect(animal).to(beAKindOf(Dog.self))
            }
            it("should resolve specific type") {
                container.register(Dog.init).as(Animal.self)
                let animal: Dog = container.resolve()
                expect(animal).to(beAKindOf(Dog.self))
            }
            it("should resolve with specific type as parameter") {
                container.register(Cat.init).as(Animal.self)
                container.register(Dog.init).as(Animal.self)
                let animal: Animal = container.resolve(Dog.self)
                expect(animal).to(beAKindOf(Dog.self))
            }
        }
        describe("when registering types") {
            var container: Container!
            beforeEach {
                container = Container()
            }
            it("with 0...5 dependencies") {
                container.register(Object0.init)
                container.register(Object1.init)
                container.register { Object2(dependency: $0, dependency2: $1) }
                container.register(Object3.init)
                container.register(Object4.init)
                container.register(Object5.init)
            }
        }
        describe("when resolving types") {
            var container: Container!
            beforeEach {
                container = Container()
                container.register(Object0.init)
                container.register(Object1.init)
                container.register(Object2.init)
                container.register(Object3.init)
                container.register(Object4.init)
                container.register(Object5.init)
            }
            it("with 0...5 dependencies") {
                let obj0: Object0 = container.resolve()
                let obj1: Object1 = container.resolve()
                let obj2: Object2 = container.resolve()
                let obj3: Object3 = container.resolve()
                let obj4: Object4 = container.resolve()
                let obj5: Object5 = container.resolve()

                expect(obj0).to(beAKindOf(Object0.self))
                expect(obj1).to(beAKindOf(Object1.self))
                expect(obj2).to(beAKindOf(Object2.self))
                expect(obj3).to(beAKindOf(Object3.self))
                expect(obj4).to(beAKindOf(Object4.self))
                expect(obj5).to(beAKindOf(Object5.self))
            }
            it("should fail for unregistered type") {
                expect{ _ = container.resolve() as SomeType }.to(throwAssertion())
            }
            it("should fail for unregistered dependency") {
                container.register(SomeType.init)
                expect{ _ = container.resolve() as SomeType }.to(throwAssertion())
            }
        }
        describe("when resolving types for") {
            var container: Container!
            describe("instance scope") {
                beforeEach {
                    container = Container()
                }
                it("should create new instance whenever needed specified type") {
                    container.register(Object0.init)
                    container.register(Object1.init)
                    container.register(Object2.init)

                    _ = container.resolve() as Object0
                    _ = container.resolve() as Object1
                    _ = container.resolve() as Object2

                    expect(container.instanceCountFor(Object0.self)).to(equal(4))
                }
            }
            describe("shared scope") {
                beforeEach {
                    container = Container()
                }
                it("should use same instance when building tree") {
                    container.register(scope: .shared, Object0.init)
                    container.register(Object1.init)
                    container.register(Object2.init)

                    _ = container.resolve() as Object2

                    expect(container.instanceCountFor(Object0.self)).to(equal(1))
                }
                it("should use create new instances for different trees") {
                    container.register(scope: .shared, Object0.init)
                    container.register(Object1.init)
                    container.register(Object2.init)

                    _ = container.resolve() as Object2
                    _ = container.resolve() as Object2

                    expect(container.instanceCountFor(Object0.self)).to(equal(2))
                }
            }
            describe("singleton scope") {
                beforeEach {
                    container = Container()
                }
                it("should use same instance on whenever needed") {
                    container.register(scope: .singleton, Object0.init)
                    container.register(Object1.init)
                    container.register(Object2.init)

                    _ = container.resolve() as Object2
                    _ = container.resolve() as Object2

                    expect(container.instanceCountFor(Object0.self)).to(equal(1))
                }
            }
        }
    }
}

