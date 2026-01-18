local M = {
  PrDescription = {
    strategy = "chat",
    description = "Github Pull Requestの説明文を作成する",
    opts = { is_slash_cmd = true },
    references = {
      {
        type = "file",
        path = { ".github/PULL_REQUEST_TEMPLATE.md" },
      },
    },
    prompts = {
      {
        role = "user",
        content = function()
          local pr = vim.fn.input("PR番号を入力してください: ")
          if pr == "" then
            vim.notify("PR番号が未入力です", vim.log.levels.ERROR)
            return nil
          end

          local commits = vim.fn.systemlist("gh pr view " .. pr .. " --json commits --jq '.commits[].oid'")
          if #commits == 0 then
            vim.notify("コミットが取得できませんでした", vim.log.levels.ERROR)
            return nil
          end

          local first = commits[1]
          local last = commits[#commits]
          local diff = vim.fn.systemlist("git diff " .. first .. "^.." .. last)

          return string.format([[
                  以下の git diff に基づいて GitHub Pull Request の説明をすべて日本語で作成してください。
                  目的、主な変更点、関連するコンテキストを含めてください。
                  エンジニアがレビューしやすく、資産として残るような完璧な説明となるようにしてください。

                  また、GitHub Pull Request の説明は、PULL_REQUEST_TEMPLATE.md をテンプレートとして活用してください。
                  コミット内容の説明については、次に続くコミット情報を元に判断してください。

                  # diff:
                  %s

                  # commits:
                  %s
                ]], table.concat(diff, "\n"), table.concat(commits, "\n"))
        end,
      },
    },
  },
  PrReviewRuby = {
    strategy = "chat",
    description = "Github Pull RequestのPR Reviewをする",
    opts = { is_slash_cmd = true },
    prompts = {
      {
        role = "system",
        content = [[
                  あなたは10年以上の経験を持つ上級Ruby on Railsエンジニアです。
                  以下のコードに対して、プロフェッショナルなコードレビューを行ってください。

                  ## レビューの観点（必ずすべて網羅してください）

                  1. **コードの意図が明確か**
                     - 命名の適切さ（モデル名、変数名、メソッド名）
                     - コメントの有無と内容の妥当性

                  2. **Railsのベストプラクティスに沿っているか**
                     - Fat Model / Skinny Controller
                     - ActiveRecordの使い方（N+1やスコープ）
                     - Strong Parametersやバリデーションの活用

                  3. **パフォーマンス面の懸念**
                     - 不要なクエリ、N+1の発生有無
                     - 無駄な処理やロジックの繰り返し

                  4. **保守性と再利用性**
                     - 冗長なコードの削減提案
                     - ヘルパーやConcernに切り出すべきロジックの指摘

                  5. **セキュリティ上懸念点**
                     - SQLインジェクションやCSRF、XSSの可能性
                     - ユーザー入力の扱いの妥当性

                  6. **テストしやすいコードか**
                     - テスト容易性と関心の分離
                     - 不要な依存の排除提案

                  7. **書き換え案があれば具体的なコードで提示**
                     - diff形式またはbefore/after形式で示す

                  8. **影響範囲が広すぎないか**
                     - 改修が影響する範囲を確認する(例: methodをgrepするなど)
                     - 影響する範囲が広すぎる場合は、PRを分けるや、実装を調整するなどを具体的に提案する

                  ## レビューの出力形式

                  - 観点ごとに項目を分け、簡潔かつ網羅的に記載
                  - 否定的な指摘も、建設的かつ改善案付きで示す
                  - もし問題がなければ「特に問題なし」と明記
                  - 問題のある部分は、強調する
                    - 🔴 [重大]: バグ、リアクティビティ喪失、論理エラー
                    - 🟡 [警告]: 非推奨な書き方、パフォーマンス懸念、Props定義の不足
                    - 🔵 [提案]: 可読性向上、ES6+の構文（アロー関数、分割代入など）の活用提案
                ]]
      },
      {
        role = "user",
        content = function()
          local pr = vim.fn.input("PR番号を入力してください: ")
          if pr == "" then
            vim.notify("PR番号が未入力です", vim.log.levels.ERROR)
            return nil
          end

          local commits = vim.fn.systemlist("gh pr view " .. pr .. " --json commits --jq '.commits[].oid'")
          if #commits == 0 then
            vim.notify("コミットが取得できませんでした", vim.log.levels.ERROR)
            return nil
          end

          local first = commits[1]
          local last = commits[#commits]
          local files = vim.fn.systemlist("git diff --name-only " .. first .. ".." .. last)
          local diff = vim.fn.systemlist("git diff " .. first .. ".." .. last)

          return string.format([[
                    以下がレビュー対象のコードです:
                    # files:
                    %s

                    # commits:
                    %s

                    # diff:
                    %s
                  ]], table.concat(files, "\n"), table.concat(commits, "\n"), table.concat(diff, "\n"))
        end,
      },
    },
  },
  PrReviewVueOld = {
    strategy = "chat",
    description = "Github Pull RequestのPR Reviewをする",
    opts = { is_slash_cmd = true },
    prompts = {
      {
        role = "system",
        content = [[
                  あなたは熟練したSenior Frontend Engineerであり、Vue.jsのエキスパートです。
                  以下のコードは **Vue 2.7 (JavaScript)** で書かれています。
                  このコードに対して、Vue 2.7の特性（Composition APIの使用と、Vue 2由来のリアクティビティ制限）を考慮したプロフェッショナルなコードレビューを行ってください。

                  ## レビューの観点（必ずすべて網羅してください）

                  1. **コードの意図が明確か**
                     - 命名の適切さ（モデル名、変数名、メソッド名）
                     - コメントの有無と内容の妥当性

                  2. **vueのベストプラクティスに沿っているか**
                     1. **Composition API (JavaScript) の適切な使用:**
                       - `<script setup>` 構文、または `setup()` 関数が正しく使われているか。
                       - `ref`, `reactive`, `computed`, `watch` の使い分けは適切か。
                       - `defineProps` や `defineEmits` の定義が、JavaScriptの構文として正しく記述されているか（型引数ではなくランタイム宣言がされているか）。

                    2. **Vue 2.7 特有のリアクティビティの注意点 (最重要):**
                       - Vue 2.7は構文がVue 3風でも、内部はVue 2（Object.defineProperty）です。
                       - `reactive` オブジェクトへのプロパティ追加や配列のインデックス操作など、Vue 2の仕組みでは検知できない変更が含まれていないか厳しくチェックしてください。
                       - 分割代入によってリアクティビティが失われている箇所 (`toRefs`が必要な箇所など) がないか。

                    3. **コードの堅牢性と可読性:**
                       - JavaScript特有の未定義エラー（undefined参照など）が起きそうな箇所はないか。
                       - Propsのバリデーション（`type`, `required`, `default`, `validator`）は十分に定義されているか。

                    4. **Vue 3 移行への準備:**
                       - 将来的に Vue 3 へ完全移行する際に障害となる書き方（非推奨なライフサイクルフックや、Mixinの乱用など）がないか。

                  3. **パフォーマンス面の懸念**
                     - 不要なクエリ、N+1の発生有無
                     - 無駄な処理やロジックの繰り返し

                  4. **保守性と再利用性**
                     - 冗長なコードの削減提案
                     - ヘルパーやConcernに切り出すべきロジックの指摘

                  5. **セキュリティ上懸念点**
                     - SQLインジェクションやCSRF、XSSの可能性
                     - ユーザー入力の扱いの妥当性

                  6. **テストしやすいコードか**
                     - テスト容易性と関心の分離
                     - 不要な依存の排除提案

                  7. **書き換え案があれば具体的なコードで提示**
                     - diff形式またはbefore/after形式で示す

                  8. **影響範囲が広すぎないか**
                     - 改修が影響する範囲を確認する(例: methodをgrepするなど)
                     - 影響する範囲が広すぎる場合は、PRを分けるや、実装を調整するなどを具体的に提案する

                  ## レビューの出力形式

                  - 観点ごとに項目を分け、簡潔かつ網羅的に記載
                  - 否定的な指摘も、建設的かつ改善案付きで示す
                  - もし問題がなければ「特に問題なし」と明記
                  - 問題のある部分は、強調する
                    - 🔴 [重大]: バグ、リアクティビティ喪失、論理エラー
                    - 🟡 [警告]: 非推奨な書き方、パフォーマンス懸念、Props定義の不足
                    - 🔵 [提案]: 可読性向上、ES6+の構文（アロー関数、分割代入など）の活用提案
                ]]
      },
      {
        role = "user",
        content = function()
          local pr = vim.fn.input("PR番号を入力してください: ")
          if pr == "" then
            vim.notify("PR番号が未入力です", vim.log.levels.ERROR)
            return nil
          end

          local commits = vim.fn.systemlist("gh pr view " .. pr .. " --json commits --jq '.commits[].oid'")
          if #commits == 0 then
            vim.notify("コミットが取得できませんでした", vim.log.levels.ERROR)
            return nil
          end

          local first = commits[1]
          local last = commits[#commits]
          local files = vim.fn.systemlist("git diff --name-only " .. first .. ".." .. last)
          local diff = vim.fn.systemlist("git diff " .. first .. ".." .. last)

          return string.format([[
                    以下がレビュー対象のコードです:
                    # files:
                    %s

                    # commits:
                    %s

                    # diff:
                    %s
                  ]], table.concat(files, "\n"), table.concat(commits, "\n"), table.concat(diff, "\n"))
        end,
      },
    },
  },
  PrReviewNuxt = {
    strategy = "chat",
    description = "Github Pull RequestのPR Reviewをする",
    opts = { is_slash_cmd = true },
    prompts = {
      {
        role = "system",
        content = [[
                  あなたは熟練したSenior Frontend Engineerであり、Nuxt.jsのエキスパートです。
                  このコードに対して、プロフェッショナルなコードレビューを行ってください。

                  ## レビューの観点（必ずすべて網羅してください）

                  1. **コードの意図が明確か**
                     - 命名の適切さ（モデル名、変数名、メソッド名）
                     - コメントの有無と内容の妥当性

                  2. **vueのベストプラクティスに沿っているか**
                     1. **Composition API (JavaScript) の適切な使用:**
                       - `<script setup>` 構文、または `setup()` 関数が正しく使われているか。
                       - `ref`, `reactive`, `computed`, `watch` の使い分けは適切か。
                       - `defineProps` や `defineEmits` の定義が、JavaScriptの構文として正しく記述されているか（型引数ではなくランタイム宣言がされているか）。

                    2. **Vue 2.7 特有のリアクティビティの注意点 (最重要):**
                       - Vue 2.7は構文がVue 3風でも、内部はVue 2（Object.defineProperty）です。
                       - `reactive` オブジェクトへのプロパティ追加や配列のインデックス操作など、Vue 2の仕組みでは検知できない変更が含まれていないか厳しくチェックしてください。
                       - 分割代入によってリアクティビティが失われている箇所 (`toRefs`が必要な箇所など) がないか。

                    3. **コードの堅牢性と可読性:**
                       - JavaScript特有の未定義エラー（undefined参照など）が起きそうな箇所はないか。
                       - Propsのバリデーション（`type`, `required`, `default`, `validator`）は十分に定義されているか。

                  3. **パフォーマンス面の懸念**
                     - 不要なクエリ、N+1の発生有無
                     - 無駄な処理やロジックの繰り返し

                  4. **保守性と再利用性**
                     - 冗長なコードの削減提案
                     - ヘルパーやConcernに切り出すべきロジックの指摘

                  5. **セキュリティ上懸念点**
                     - SQLインジェクションやCSRF、XSSの可能性
                     - ユーザー入力の扱いの妥当性

                  6. **テストしやすいコードか**
                     - テスト容易性と関心の分離
                     - 不要な依存の排除提案

                  7. **書き換え案があれば具体的なコードで提示**
                     - diff形式またはbefore/after形式で示す

                  8. **影響範囲が広すぎないか**
                     - 改修が影響する範囲を確認する(例: methodをgrepするなど)
                     - 影響する範囲が広すぎる場合は、PRを分けるや、実装を調整するなどを具体的に提案する

                  ## レビューの出力形式

                  - 観点ごとに項目を分け、簡潔かつ網羅的に記載
                  - 否定的な指摘も、建設的かつ改善案付きで示す
                  - もし問題がなければ「特に問題なし」と明記
                  - 問題のある部分は、強調する
                    - 🔴 [重大]: バグ、リアクティビティ喪失、論理エラー
                    - 🟡 [警告]: 非推奨な書き方、パフォーマンス懸念、Props定義の不足
                    - 🔵 [提案]: 可読性向上、ES6+の構文（アロー関数、分割代入など）の活用提案
                ]]
      },
      {
        role = "user",
        content = function()
          local pr = vim.fn.input("PR番号を入力してください: ")
          if pr == "" then
            vim.notify("PR番号が未入力です", vim.log.levels.ERROR)
            return nil
          end

          local commits = vim.fn.systemlist("gh pr view " .. pr .. " --json commits --jq '.commits[].oid'")
          if #commits == 0 then
            vim.notify("コミットが取得できませんでした", vim.log.levels.ERROR)
            return nil
          end

          local first = commits[1]
          local last = commits[#commits]
          local files = vim.fn.systemlist("git diff --name-only " .. first .. ".." .. last)
          local diff = vim.fn.systemlist("git diff " .. first .. ".." .. last)

          return string.format([[
                    以下がレビュー対象のコードです:
                    # files:
                    %s

                    # commits:
                    %s

                    # diff:
                    %s
                  ]], table.concat(files, "\n"), table.concat(commits, "\n"), table.concat(diff, "\n"))
        end,
      },
    },
  },
  Explain = {
    strategy = "chat",
    description = "コードを日本語で説明する",
    opts = { short_name = "explain", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "このコードを日本語で説明してください。",
      },
    },
  },
  GenerateExample = {
    strategy = "chat",
    description = "使い方の具体例を生成する",
    opts = { short_name = "example", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "このコードの使い方を示す具体的な例を日本語で生成してください。",
      },
    },
  },
  Review = {
    strategy = "chat",
    description = "コードレビューを依頼する",
    opts = { short_name = "review", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "このコードを日本語でレビューしてください。",
      },
    },
  },
  Fix = {
    strategy = "chat",
    description = "コードのバグ修正を依頼する",
    opts = { short_name = "fix", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
      },
    },
  },
  SolveError = {
    strategy = "chat",
    description = "エラー解決のアドバイスをもらう",
    opts = { short_name = "error", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したエラーメッセージに対する解決方法を日本語で教えてください。",
      },
    },
  },
  Optimize = {
    strategy = "chat",
    description = "パフォーマンスと可読性の最適化",
    opts = { short_name = "optimize", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したコードを最適化し、パフォーマンスと可読性（特にネーミング）を向上させてください。説明は日本語でお願いします。",
      },
    },
  },
  Docs = {
    strategy = "chat",
    description = "ドキュメントコメントを生成する",
    opts = { short_name = "docs", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したコードに関するドキュメントコメントを日本語で生成してください。",
      },
    },
  },
  DocsAnnotation = {
    strategy = "inline",
    description = "methodのAnnotationを生成する",
    opts = { short_name = "docs_annotation", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したコードに関するAnnotationを、コードリーディングがしやすくなるように生成してください。",
      },
    },
  },
  GenerateCode = {
    strategy = "inline",
    description = "機能実装コードを生成する",
    opts = { short_name = "gen_code", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "特定の機能を実装するコードを生成してください。説明は日本語でお願いします。",
      },
    },
  },
  Translate = {
    strategy = "inline",
    description = "コードを他言語に変換する",
    opts = { short_name = "translate", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したコードを別のプログラミング言語に変換してください。説明は日本語でお願いします。",
      },
    },
  },
  SuggestRefactor = {
    strategy = "chat",
    description = "改善提案をお願いする",
    opts = { short_name = "suggest", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したコードの改善提案をください。説明は日本語でお願いします。",
      },
    },
  },
  Debug = {
    strategy = "chat",
    description = "バグの原因を探る",
    opts = { short_name = "debug", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したコードのバグを見つけてください。説明は日本語でお願いします。",
      },
    },
  },
  Tests = {
    strategy = "chat",
    description = "ユニットテストを生成する",
    opts = { short_name = "tests", is_slash_cmd = true },
    prompts = {
      {
        role = "user",
        content = "選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
      },
    },
  },
  Commit = {
    strategy = "chat",
    description = "コミットメッセージを生成する",
    opts = { short_name = "commit", is_slash_cmd = true },
    references = {
      {
        type = "url",
        url = "https://www.conventionalcommits.org/en/v1.0.0/",
      },
    },
    prompts = {
      {
        role = "user",
        content = [[
以下の条件に基づいて、英語でコミットメッセージを生成してください:
1. Conventional Commits の形式を使用する。
2. 差分内容に基づき、適切なプレフィックス (e.g., feat, fix, chore, docs, refactor, test) を付与する。
3. タイトルは簡潔的に、先頭を動詞かつ大文字で簡潔に記載する。
4. 本文は変更の目的や背景を文章で記載して、変更の概要を箇条書きで説明する。
        ]],
      },
    },
  },
  CommitMessage = {
    strategy = "chat",
    description = "ステージ済み差分からコミットメッセージを生成する",
    opts = { is_slash_cmd = true },
    -- references = {
    --   {
    --     type = "url",
    --     url = "https://www.conventionalcommits.org/en/v1.0.0/",
    --   },
    -- },
    prompts = {
      {
        role = "system",
        content = [[
                以下の条件に基づいて、英語でコミットメッセージを生成してください:
                1. Conventional Commits の形式を使用する。
                2. 1行は100文字しないとする
                3. 差分内容に基づき、適切なプレフィックス (e.g., feat, fix, chore, docs, refactor, test) を付与する。
                4. タイトルは簡潔的に、先頭を動詞かつ大文字で簡潔に記載する。また、コミットで使う動詞に関しては、基本的かつよく使われる動詞を使い、統一したタイトルとなるようにすること。
                5. 本文は変更の目的や背景を文章を記載する
                6. その後に、変更内容を箇条書きで説明する。
                ]]
      },
      {
        role = "user",
        content = function()
          local diff = vim.fn.systemlist("git diff --cached")
          return string.format([[
以下のdiffの内容を元に適切なコミットメッセージを作成してください。

```git
%s
```
          ]], table.concat(diff, "\n"))
        end,
      },
    },
  },
}

return M
