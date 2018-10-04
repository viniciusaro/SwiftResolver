import SwiftResolver

protocol Human {

}

final class Child {}

final class Father: Human {
    let child: Child
    init(child: Child) {
        self.child = child
    }
}

final class Mother: Human {
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

let container = Container { registrant in
    registrant.register(scope: .shared) { Child() }
    registrant.register { Father(child: $0) }.as(Human.self)
    registrant.register { Mother(child: $0) }.as(Human.self)
    registrant.register { Family(father: $0, mother: $1, child: $2) }
}

let father = container.resolve() as Father
let human: Human = container.resolve(Mother.self)

let family = container.resolve() as Family
family.father.child === family.child
family.mother.child === family.child
family.mother.child === family.father.child

let family2 = container.resolve() as Family
family.child === family2.child

