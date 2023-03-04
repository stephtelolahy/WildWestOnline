// MARK: - Mocks generated from file: Sources/CardGame/CardGame.swift at 2023-03-04 12:29:50 +0000


import Cuckoo
@testable import CardGame

import GameDSL






 class MockCardGame: CardGame, Cuckoo.ProtocolMock {
    
     typealias MocksType = CardGame
    
     typealias Stubbing = __StubbingProxy_CardGame
     typealias Verification = __VerificationProxy_CardGame

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CardGame?

     func enableDefaultImplementation(_ stub: CardGame) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var isOver: Bool {
        get {
            return cuckoo_manager.getter("isOver",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isOver)
        }
        
    }
    
    
    
    
    
     var event: Result<Event, Error>? {
        get {
            return cuckoo_manager.getter("event",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.event)
        }
        
        set {
            cuckoo_manager.setter("event",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.event = newValue)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_CardGame: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var isOver: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCardGame, Bool> {
            return .init(manager: cuckoo_manager, name: "isOver")
        }
        
        
        
        
        var event: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCardGame, Result<Event, Error>> {
            return .init(manager: cuckoo_manager, name: "event")
        }
        
        
        
    }

     struct __VerificationProxy_CardGame: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var isOver: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isOver", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var event: Cuckoo.VerifyOptionalProperty<Result<Event, Error>> {
            return .init(manager: cuckoo_manager, name: "event", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


 class CardGameStub: CardGame {
    
    
    
    
     var isOver: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
     var event: Result<Event, Error>? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Result<Event, Error>?).self)
        }
        
        set { }
        
    }
    
    

    

    
}





// MARK: - Mocks generated from file: Sources/CardGame/CardGameEngine.swift at 2023-03-04 12:29:50 +0000


import Cuckoo
@testable import CardGame

import Combine
import Foundation
import GameDSL






public class MockCardGameEngineRule: CardGameEngineRule, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CardGameEngineRule
    
    public typealias Stubbing = __StubbingProxy_CardGameEngineRule
    public typealias Verification = __VerificationProxy_CardGameEngineRule

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CardGameEngineRule?

    public func enableDefaultImplementation(_ stub: CardGameEngineRule) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func triggered(_ ctx: Game) -> [Event]? {
        
    return cuckoo_manager.call(
    """
    triggered(_: Game) -> [Event]?
    """,
            parameters: (ctx),
            escapingParameters: (ctx),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.triggered(ctx))
        
    }
    
    
    
    
    
    public func active(_ ctx: Game) -> [Event]? {
        
    return cuckoo_manager.call(
    """
    active(_: Game) -> [Event]?
    """,
            parameters: (ctx),
            escapingParameters: (ctx),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.active(ctx))
        
    }
    
    

    public struct __StubbingProxy_CardGameEngineRule: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func triggered<M1: Cuckoo.Matchable>(_ ctx: M1) -> Cuckoo.ProtocolStubFunction<(Game), [Event]?> where M1.MatchedType == Game {
            let matchers: [Cuckoo.ParameterMatcher<(Game)>] = [wrap(matchable: ctx) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCardGameEngineRule.self, method:
    """
    triggered(_: Game) -> [Event]?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func active<M1: Cuckoo.Matchable>(_ ctx: M1) -> Cuckoo.ProtocolStubFunction<(Game), [Event]?> where M1.MatchedType == Game {
            let matchers: [Cuckoo.ParameterMatcher<(Game)>] = [wrap(matchable: ctx) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCardGameEngineRule.self, method:
    """
    active(_: Game) -> [Event]?
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_CardGameEngineRule: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func triggered<M1: Cuckoo.Matchable>(_ ctx: M1) -> Cuckoo.__DoNotUse<(Game), [Event]?> where M1.MatchedType == Game {
            let matchers: [Cuckoo.ParameterMatcher<(Game)>] = [wrap(matchable: ctx) { $0 }]
            return cuckoo_manager.verify(
    """
    triggered(_: Game) -> [Event]?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func active<M1: Cuckoo.Matchable>(_ ctx: M1) -> Cuckoo.__DoNotUse<(Game), [Event]?> where M1.MatchedType == Game {
            let matchers: [Cuckoo.ParameterMatcher<(Game)>] = [wrap(matchable: ctx) { $0 }]
            return cuckoo_manager.verify(
    """
    active(_: Game) -> [Event]?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class CardGameEngineRuleStub: CardGameEngineRule {
    

    

    
    
    
    
    public func triggered(_ ctx: Game) -> [Event]?  {
        return DefaultValueRegistry.defaultValue(for: ([Event]?).self)
    }
    
    
    
    
    
    public func active(_ ctx: Game) -> [Event]?  {
        return DefaultValueRegistry.defaultValue(for: ([Event]?).self)
    }
    
    
}




