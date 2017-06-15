import Foundation

final class SomeDependency {}
final class SomeType {
    let dependency: SomeDependency
    init(dependency: SomeDependency) {
        self.dependency = dependency
    }
}

final class Object0 {}

final class Object1 {
    let dependency: Object0
    init(dependency: Object0) {
        self.dependency = dependency
    }
}

final class Object2 {
    let dependency: Object0
    let dependency2: Object1
    init(dependency: Object0, dependency2: Object1) {
        self.dependency = dependency
        self.dependency2 = dependency2
    }
}

final class Object3 {
    let dependency: Object0
    let dependency2: Object1
    let dependency3: Object2
    init(dependency: Object0, dependency2: Object1, dependency3: Object2) {
        self.dependency = dependency
        self.dependency2 = dependency2
        self.dependency3 = dependency3
    }
}

final class Object4 {
    let dependency: Object0
    let dependency2: Object1
    let dependency3: Object2
    let dependency4: Object3
    init(dependency: Object0, dependency2: Object1, dependency3: Object2, dependency4: Object3) {
        self.dependency = dependency
        self.dependency2 = dependency2
        self.dependency3 = dependency3
        self.dependency4 = dependency4
    }
}

final class Object5 {
    let dependency: Object0
    let dependency2: Object1
    let dependency3: Object2
    let dependency4: Object3
    let dependency5: Object4
    
    init(dependency: Object0,
         dependency2: Object1,
         dependency3: Object2,
         dependency4: Object3,
         dependency5: Object4) {
        self.dependency = dependency
        self.dependency2 = dependency2
        self.dependency3 = dependency3
        self.dependency4 = dependency4
        self.dependency5 = dependency5
    }
}
