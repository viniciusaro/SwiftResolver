import XCTest
@testable import Resolver

class ContainerTests: XCTestCase {
    
    func testItShouldNotCreateReferenceCycles() {
        var container: Container! = Container()
        weak var weakContainer: Container? = container
        container.register(scope: .instance, Object0.init)
        container.register(scope: .shared, Object1.init)
        container.register(scope: .singleton, Object2.init)
        _ = container.resolve() as Object0
        _ = container.resolve() as Object1
        _ = container.resolve() as Object2
        container = nil
        XCTAssertNil(weakContainer)
    }
    
    func testItShouldResolveTypesCorrectly() {
        let container = Container()
        container.register(Object0.init)
        container.register(Object1.init)
        container.register(Object2.init)
        container.register(Object3.init)
        container.register(Object4.init)
        container.register(Object5.init)
        
        let obj0: Object0 = container.resolve()
        let obj1: Object1 = container.resolve()
        let obj2: Object2 = container.resolve()
        let obj3: Object3 = container.resolve()
        let obj4: Object4 = container.resolve()
        let obj5: Object5 = container.resolve()
        
        XCTAssertTrue(type(of: obj0) == Object0.self)
        XCTAssertTrue(type(of: obj1) == Object1.self)
        XCTAssertTrue(type(of: obj2) == Object2.self)
        XCTAssertTrue(type(of: obj3) == Object3.self)
        XCTAssertTrue(type(of: obj4) == Object4.self)
        XCTAssertTrue(type(of: obj5) == Object5.self)
    }
    
    func testItShouldFailToResolveUnregisteredType() {
        let container = Container()
        XCTAssertThrowsError(container.resolve() as SomeType)
    }
}

//import Quick
//import Nimble
//@testable import NNDataManager
//
//class ContainerTests: QuickSpec {
//    override func spec() {
//            it("should fail for unregistered type") {
//                expect{ _ = container.resolve() as SomeType }.to(throwAssertion())
//            }
//            it("should fail for unregistered dependency") {
//                container.register(SomeType.init)
//                expect{ _ = container.resolve() as SomeType }.to(throwAssertion())
//            }
//        describe("when resolving types for") {
//            var container: Container!
//            describe("instance scope") {
//                beforeEach {
//                    container = Container()
//                }
//                it("should create new instance whenever needed specified type") {
//                    container.register(Object0.init)
//                    container.register(Object1.init)
//                    container.register(Object2.init)
//
//                    _ = container.resolve() as Object0
//                    _ = container.resolve() as Object1
//                    _ = container.resolve() as Object2
//
//                    expect(container.instanceCountFor(Object0.self)).to(equal(4))
//                }
//            }
//            describe("shared scope") {
//                beforeEach {
//                    container = Container()
//                }
//                it("should use same instance when building tree") {
//                    container.register(scope: .shared, Object0.init)
//                    container.register(Object1.init)
//                    container.register(Object2.init)
//
//                    _ = container.resolve() as Object2
//
//                    expect(container.instanceCountFor(Object0.self)).to(equal(1))
//                }
//                it("should use create new instances for different trees") {
//                    container.register(scope: .shared, Object0.init)
//                    container.register(Object1.init)
//                    container.register(Object2.init)
//
//                    _ = container.resolve() as Object2
//                    _ = container.resolve() as Object2
//
//                    expect(container.instanceCountFor(Object0.self)).to(equal(2))
//                }
//            }
//            describe("singleton scope") {
//                beforeEach {
//                    container = Container()
//                }
//                it("should use same instance on whenever needed") {
//                    container.register(scope: .singleton, Object0.init)
//                    container.register(Object1.init)
//                    container.register(Object2.init)
//
//                    _ = container.resolve() as Object2
//                    _ = container.resolve() as Object2
//
//                    expect(container.instanceCountFor(Object0.self)).to(equal(1))
//                }
//            }
//        }
//    }
//}

