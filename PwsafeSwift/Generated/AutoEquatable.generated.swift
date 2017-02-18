// Generated using Sourcery 0.5.5 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}

// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - Group AutoEquatable
extension Group: Equatable {} 
public func == (lhs: Group, rhs: Group) -> Bool {
    guard lhs.segments == rhs.segments else { return false }
    guard lhs.hashValue == rhs.hashValue else { return false }
    return true
}
// MARK: - Pwsafe AutoEquatable
extension Pwsafe: Equatable {} 
public func == (lhs: Pwsafe, rhs: Pwsafe) -> Bool {
    guard lhs.header == rhs.header else { return false }
    guard lhs.records == rhs.records else { return false }
    guard lhs.groups == rhs.groups else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

// MARK: -
