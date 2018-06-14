import Quick
import Nimble
@testable import SwiftResolver

class ContainerTests: QuickSpec {
    override func spec() {
        describe("when deallocating") {
            it("should not create reference cycles") {
                var container: Container! = Container()
                weak var weakContainer: Container? = container
                container.register(scope: .instance, Child.init)
                container.register(scope: .shared, Father.init)
                container.register(scope: .singleton, Mother.init)
                container.register(Family.init)
                container.register(House.init)
                container.register(Street.init)
                _ = container.resolve() as Child
                _ = container.resolve() as Father
                _ = container.resolve() as Mother
                _ = container.resolve() as Family
                _ = container.resolve() as House
                _ = container.resolve() as Street
                container = nil
                expect(weakContainer).to(beNil())
            }
        }
        describe("when registering with tags") {
            var container: Container!
            beforeEach {
                container = Container()
            }
            it("should resolve same type with different tags") {
                container.register { Dog.with(name: "Téo") }.tag(Dogs.teo)
                container.register { Dog.with(name: "Bob") }.tag(Dogs.bob)
                let teo = container.resolve(Dogs.teo) as Dog
                let bob = container.resolve(Dogs.bob) as Dog
                expect(teo.name).to(equal("Téo"))
                expect(bob.name).to(equal("Bob"))
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
                container.register(Child.init)
                container.register(Mother.init)
                container.register { Family(father: $0, mother: $1, child: $2) }
                container.register(Father.init)
                container.register(House.init)
                container.register(Street.init)
            }
        }
        describe("when resolving types") {
            var container: Container!
            beforeEach {
                container = Container()
                container.register(Child.init)
                container.register(Father.init)
                container.register(Mother.init)
                container.register(Family.init)
                container.register(House.init)
                container.register(Street.init)
            }
            it("with 0...5 dependencies") {
                let child: Child = container.resolve()
                let father: Father = container.resolve()
                let mother: Mother = container.resolve()
                let family: Family = container.resolve()
                let house: House = container.resolve()
                let street: Street = container.resolve()

                expect(child).to(beAKindOf(Child.self))
                expect(father).to(beAKindOf(Father.self))
                expect(mother).to(beAKindOf(Mother.self))
                expect(family).to(beAKindOf(Family.self))
                expect(house).to(beAKindOf(House.self))
                expect(street).to(beAKindOf(Street.self))
            }
            it("should fail for unregistered type") {
                expect { _ = container.resolve() as SomeType }.to(throwAssertion())
            }
            it("should fail for unregistered dependency") {
                container.register(SomeType.init)
                expect { _ = container.resolve() as SomeType }.to(throwAssertion())
            }
        }
        describe("when resolving types for") {
            var container: Container!
            describe("instance scope") {
                beforeEach {
                    container = Container()
                }
                it("should create new instance whenever needed specified type") {
                    container.register(Child.init)
                    container.register(Father.init)
                    container.register(Mother.init)

                    let child = container.resolve() as Child
                    let father = container.resolve() as Father
                    let mother = container.resolve() as Mother

                    expect(container.instanceCountFor(Child.self)).to(equal(3))
                    expect(expression: { child !== mother.child }).to(beTrue())
                    expect(expression: { child !== father.child }).to(beTrue())
                    expect(expression: { father.child !== mother.child }).to(beTrue())
                }
            }
            describe("shared scope") {
                beforeEach {
                    container = Container()
                }
                it("should use same instance when building tree") {
                    container.register(scope: .shared, Child.init)
                    container.register(Father.init)
                    container.register(Mother.init)
                    container.register(Family.init)

                    let family = container.resolve() as Family

                    expect(container.instanceCountFor(Child.self)).to(equal(1))
                    expect(expression: { family.child === family.father.child }).to(beTrue())
                    expect(expression: { family.child === family.mother.child }).to(beTrue())
                }
                it("should use create new instances for different trees") {
                    container.register(scope: .shared, Child.init)
                    container.register(Father.init)
                    container.register(Mother.init)

                    let father = container.resolve() as Father
                    let mother = container.resolve() as Mother

                    expect(container.instanceCountFor(Child.self)).to(equal(2))
                    expect(expression: { father.child !== mother.child }).to(beTrue())
                }
                it("should use new dependency graph if resolver is called") {
                    container.register(scope: .shared, Child.init)
                    container.register(scope: .shared, Father.init)
                    container.register(Mother.init)
                    
                    container.register { Family(father: container.resolve(),
                                                mother: container.resolve(),
                                                child: container.resolve()) }

                    container.register(House.init)

                    let family = container.resolve() as Family
                    let house = container.resolve() as House
                    
                    expect(expression: { family.father.child !== family.mother.child }).to(beTrue())
                    expect(expression: { family.child !== family.mother.child }).to(beTrue())
                    expect(expression: { family.child !== family.father.child }).to(beTrue())
                    expect(expression: { house.family.father !== house.owner }).to(beTrue())
                    expect(expression: { house.family.father.child !== house.owner.child }).to(beTrue())
                }
            }
            describe("singleton scope") {
                beforeEach {
                    container = Container()
                }
                it("should use same instance on whenever needed") {
                    container.register(scope: .singleton, Child.init)
                    container.register(Father.init)
                    container.register(Mother.init)

                    let mother = container.resolve() as Mother
                    let father = container.resolve() as Father

                    expect(container.instanceCountFor(Child.self)).to(equal(1))
                    expect(expression: { mother.child === father.child }).to(beTrue())
                }
            }
        }
    }
}

