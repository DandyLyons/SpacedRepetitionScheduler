// Copyright © 2020  Brian Dewey. Covered by the Apache 2.0 license.

import Foundation

/// Determines which time interval recommendation algorithm to use with prompts.
public enum PromptSchedulingMode: Hashable, Codable, Sendable {
  /// Represents a prompt in the *learning* mode.
  ///
  /// An item stays in the learning state until it has been recalled a specific number of times, determined by the number of items in the ``SchedulingParameters/learningIntervals`` array.
  /// - parameter step: How many learning steps have been completed. `step == 0` implies a new card.
  case learning(step: Int)

  /// Represents a prompt in the *review* mode.
  ///
  /// Items in the review state are scheduled at increasingly longer intervals with each successful recall.
  case review
}

extension PromptSchedulingMode: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
      case .review: ".review"
      case .learning(step: let step): ".learning(step: \(step)"
    }
  }
}

extension PromptSchedulingMode: Comparable {
  public static func < (lhs: PromptSchedulingMode, rhs: PromptSchedulingMode) -> Bool {
    switch (lhs, rhs) {
      case (.learning(let lhsStep), .learning(let rhsStep)):
        return lhsStep < rhsStep
      case (.learning, .review):
        return true
      case (.review, .learning):
        return false
      case (.review, .review):
        return false
    }
  }
}
