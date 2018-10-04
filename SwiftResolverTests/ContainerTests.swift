import Quick
import Nimble
@testable import SwiftResolver

class ContainerTests: QuickSpec {
    override func spec() {
        describe("when deallocating") {
            it("should not create reference cycles") {
                var container: Container! = Container { registrant in
                    registrant.register(scope: .instance, Child.init)
                    registrant.register(scope: .shared, Father.init)
                    registrant.register(scope: .singleton, Mother.init)
                    registrant.register(Family.init)
                    registrant.register(House.init)
                    registrant.register(Street.init)
                }
                
                weak var weakContainer: Container? = container
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
                container = Container { registrant in
                    registrant.register { Dog.with(name: "Téo") }.tag(Dogs.teo)
                    registrant.register { Dog.with(name: "Bob") }.tag(Dogs.bob)
                }
            }
            it("should resolve same type with different tags") {
                let teo = container.resolve(Dogs.teo) as Dog
                let bob = container.resolve(Dogs.bob) as Dog
                expect(teo.name).to(equal("Téo"))
                expect(bob.name).to(equal("Bob"))
            }
        }
        describe("when registering multiple instances of the same type") {
            var container: Container!
            it("should resolve generic type") {
                container = Container { registrant in
                    registrant.register(Dog.init).as(Animal.self)
                }
                let animal: Animal = container.resolve()
                expect(animal).to(beAKindOf(Dog.self))
            }
            it("should resolve specific type") {
                container = Container { registrant in
                    registrant.register(Dog.init).as(Animal.self)
                }
                let animal: Dog = container.resolve()
                expect(animal).to(beAKindOf(Dog.self))
            }
            it("should resolve with specific type as parameter") {
                container = Container { registrant in
                    registrant.register(Cat.init).as(Animal.self)
                    registrant.register(Dog.init).as(Animal.self)
                }
                let animal: Animal = container.resolve(Dog.self)
                expect(animal).to(beAKindOf(Dog.self))
            }
        }
        describe("when registering types") {
            it("with 0...5 dependencies") {
                _ = Container { registrant in
                    registrant.register(Child.init)
                    registrant.register(Mother.init)
                    registrant.register { Family(father: $0, mother: $1, child: $2) }
                    registrant.register(Father.init)
                    registrant.register(House.init)
                    registrant.register(Street.init)
                }
            }
        }
        describe("when resolving types") {
            var container: Container!
            beforeEach {
                container = Container { registrant in
                    registrant.register(Child.init)
                    registrant.register(Father.init)
                    registrant.register(Mother.init)
                    registrant.register(Family.init)
                    registrant.register(House.init)
                    registrant.register(Street.init)
                    registrant.register(SomeType.init)
                }
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
                expect { _ = container.resolve() as SomeType }.to(throwAssertion())
            }
        }
        describe("when resolving types for") {
            var container: Container!
            describe("instance scope") {
                beforeEach {
                    container = Container { registrant in
                        registrant.register(Child.init)
                        registrant.register(Father.init)
                        registrant.register(Mother.init)
                    }
                }
                it("should create new instance whenever needed specified type") {
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
                it("should use same instance when building tree") {
                    container = Container { registrant in
                        registrant.register(scope: .shared, Child.init)
                        registrant.register(Father.init)
                        registrant.register(Mother.init)
                        registrant.register(Family.init)
                    }
                    
                    let family = container.resolve() as Family

                    expect(container.instanceCountFor(Child.self)).to(equal(1))
                    expect(expression: { family.child === family.father.child }).to(beTrue())
                    expect(expression: { family.child === family.mother.child }).to(beTrue())
                }
                it("should use create new instances for different trees") {
                    container = Container { registrant in
                        registrant.register(scope: .shared, Child.init)
                        registrant.register(Father.init)
                        registrant.register(Mother.init)
                    }

                    let father = container.resolve() as Father
                    let mother = container.resolve() as Mother

                    expect(container.instanceCountFor(Child.self)).to(equal(2))
                    expect(expression: { father.child !== mother.child }).to(beTrue())
                }
                it("should use new dependency graph if resolver is called") {
                    container = Container { registrant in
                        registrant.register(scope: .shared, Child.init)
                        registrant.register(scope: .shared, Father.init)
                        registrant.register(Mother.init)
                        
                        registrant.register { Family(father: container.resolve(),
                                                    mother: container.resolve(),
                                                    child: container.resolve()) }
                        
                        registrant.register(House.init)
                    }

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
                it("should use same instance on whenever needed") {
                    container = Container { registrant in
                        registrant.register(scope: .singleton, Child.init)
                        registrant.register(Father.init)
                        registrant.register(Mother.init)
                    }

                    let mother = container.resolve() as Mother
                    let father = container.resolve() as Father

                    expect(container.instanceCountFor(Child.self)).to(equal(1))
                    expect(expression: { mother.child === father.child }).to(beTrue())
                }
            }
        }
    }
}

