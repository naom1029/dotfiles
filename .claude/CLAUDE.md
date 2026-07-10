/ Claude Code Development Guidelines

## Language Preference

**すべての応答とプランを日本語で書いてください。**
コード例やコメントは英語でも構いませんが、説明文やドキュメントは日本語で記述すること。

## Testing Philosophy

### Classical School Testing Approach

テストは**観測可能な振る舞いと状態を確認**することによって検証する。
古典学派的なテストを行い、**外部依存以外でモックは使わない**。

### Test Validation

#### 事前条件（Preconditions）

- テスト対象のメソッド/関数が実行される前の状態を検証
- 入力データの妥当性を確認
- 必要なセットアップが正しく行われていることを確認

#### 事後条件（Postconditions）

- メソッド/関数の実行後の状態を検証
- 期待される出力値が正しいことを確認
- 副作用（状態変更、ファイル作成等）が正しく発生していることを確認

#### 不変条件（Invariants）

- オブジェクトのライフサイクル全体で常に成立すべき条件を検証
- 操作前後で維持されるべきプロパティを確認
- 例：リストのサイズ、インデックスの範囲、フィルタ後の要素の整合性

### The Four Pillars of Good Tests

#### 1. リファクタリングのしやすさ（Protection against false positives）

- 実装の詳細ではなく、公開APIや振る舞いをテストする
- テストが内部実装に依存しないことで、リファクタリング時にテストが壊れない
- 偽陽性（false positive）を避ける

#### 2. 退行への耐性（Protection against regressions）

- バグや機能の退行を確実に検出できる
- エッジケースや境界値をカバーする
- 実際のユースケースを反映したテストケース

#### 3. 素早いフィードバック（Fast feedback）

- テストは高速に実行される
- 開発サイクルを遅延させない
- CI/CDパイプラインで効率的に実行できる

#### 4. 保守のしやすさ（Maintainability）

- テストコードは読みやすく、理解しやすい
- テストの意図が明確
- 重複を避け、適切な抽象化を使用
- テストのセットアップとクリーンアップが簡潔

### AAA Pattern (Arrange-Act-Assert)

テストは必ず**AAAパターン**で記述する：

#### Arrange（準備）
- テスト対象のオブジェクトと依存関係をセットアップ
- 事前条件を準備
- 必要に応じて事前条件を検証

#### Act（実行）
- テスト対象のメソッド/関数を1回だけ実行
- **重要**: 一つのテストケースで一つのActのみ

#### Assert（検証）
- 事後条件を検証
- 観測可能な振る舞いを確認
- 不変条件が保持されているか検証

#### フォーマット規則
- **各フェーズは空行で区切る**
- Arrange、Act、Assertをコメントで明示
- **Assertフェーズは1回のみ**: 複数のActが必要なら、テストを分割する
- **一つのテストケースでは一つのことのみを検証**

```rust
#[test]
fn test_specific_behavior() {
    // Arrange
    let mut system = System::new();
    system.add_data(test_data);

    // Act
    let result = system.perform_operation();

    // Assert
    assert_eq!(result, expected_value);
    assert_invariants(&system);
}
```

### Best Practices

- **外部依存のみモックする**: データベース、外部API、ファイルシステムなど
- **内部の関数やモジュールはモックしない**: 実際の統合をテストする
- **観測可能な振る舞いに焦点を当てる**: プライベートメソッドではなく、公開APIをテストする
- **状態ベースの検証**: メソッド呼び出しの検証（モック）より、結果の状態を検証する
- **テストの独立性**: 各テストは独立して実行できるようにする
- **明確なテスト名**: テストが何を検証しているか名前から理解できる
- **Single Responsibility**: 一つのテストは一つの振る舞いのみを検証
