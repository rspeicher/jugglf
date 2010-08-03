Feature: Item Pricing

  Scenario: Head, Chest and Legs prices
    When I expect the following item prices:
      | slot  | level | price |
      | Head  | 226   | 0.50  |
      | Chest | 239   | 1.00  |
      | Legs  | 245   | 1.50  |
      | Head  | 258   | 2.00  |
      | Chest | 264   | 2.50  |
      | Legs  | 277   | 3.00  |
      | Head  | 284   | 3.50  |
    Then I should receive the correct prices

  Scenario: Shoulder, Hands and Feet prices
    When I expect the following item prices:
      | slot     | level | price |
      | Shoulder | 226   | 0.00  |
      | Hands    | 239   | 0.50  |
      | Feet     | 245   | 1.00  |
      | Shoulder | 258   | 1.50  |
      | Hands    | 264   | 2.00  |
      | Feet     | 277   | 2.50  |
      | Shoulder | 284   | 3.00  |
    Then I should receive the correct prices

  Scenario: Wrist, Waist and Finger prices
    When I expect the following item prices:
      | slot   | level | price |
      | Wrist  | 226   | 0.00  |
      | Waist  | 239   | 0.00  |
      | Finger | 245   | 0.50  |
      | Wrist  | 258   | 1.00  |
      | Waist  | 264   | 1.50  |
      | Finger | 277   | 2.00  |
      | Wrist  | 284   | 2.50  |
    Then I should receive the correct prices

  Scenario: Neck prices
    When I expect the following item prices:
      | slot | level | price |
      | Neck | 226   | 0.00  |
      | Neck | 239   | 0.00  |
      | Neck | 245   | 0.50  |
      | Neck | 258   | 1.00  |
      | Neck | 264   | 1.50  |
      | Neck | 277   | 2.00  |
      | Neck | 284   | 2.50  |
    Then I should receive the correct prices

  Scenario: Back prices
    When I expect the following item prices:
      | slot | level | price |
      | Back | 226   | 0.00  |
      | Back | 239   | 0.00  |
      | Back | 245   | 0.50  |
      | Back | 258   | 0.50  |
      | Back | 264   | 0.50  |
      | Back | 272   | 0.50  |
      | Back | 277   | 0.50  |
      | Back | 284   | 3.00  |
    Then I should receive the correct prices

  Scenario: Two-Hand prices
    When I expect the following item prices:
      | slot     | level | class   | price |
      | Two-Hand | 226   | Druid   | 0.00  |
      | Two-Hand | 232   | Shaman  | 1.00  |
      | Two-Hand | 239   | Shaman  | 2.00  |
      | Two-Hand | 245   | Hunter  | 1.00  |
      | Two-Hand | 258   | Priest  | 4.00  |
      | Two-Hand | 264   | Hunter  | 2.00  |
      | Two-Hand | 271   | Priest  | 5.00  |
      | Two-Hand | 277   | Hunter  | 2.50  |
      | Two-Hand | 284   | Warrior | 7.00  |
    Then I should receive the correct prices

  Scenario: Melee DPS weapon prices
    When I expect the following item prices:
      | slot      | level | class        | price |
      | Main Hand | 264   | Rogue        | 2.50  |
      | Off Hand  | 264   | Rogue        | 2.50  |
      | Shield    | 264   | Shaman       | 1.50  |
      | One-Hand  | 264   | Shaman       | 2.50  |
      | One-Hand  | 264   | Death Knight | 2.50  |
      | Shield    | 264   | Warrior      | 2.50  |
      | Main Hand | 264   | Hunter       | 1.00  |
      | One-Hand  | 264   | Hunter       | 1.00  |
    Then I should receive the correct prices

  Scenario: Ranged weapon slot prices
    When I expect the following item prices:
      | slot   | level | class   | price |
      | Ranged | 264   | Hunter  | 4.00  |
      | Ranged | 264   | Rogue   | 1.00  |
      | Relic  | 264   | Paladin | 1.00  |
      | Totem  | 264   | Shaman  | 1.00  |
      | Idol   | 264   | Druid   | 1.00  |
    Then I should receive the correct prices


  Scenario: Legendary token prices
    When I expect the following item prices:
      | name                 | level | price |
      | Shadowfrost Shard    | 80    | 0.20  |
      | Fragment of Val'anyr | 80    | 0.00  |
    Then I should receive the correct prices
