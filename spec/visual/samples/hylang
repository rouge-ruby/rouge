#!/usr/bin/env hy

(import hy.core)


(defn hyghlight-names []
  (-> (hy.core.reserved.names)
      (sorted)))


(defn hyghlight-keywords []
  (sorted hy.core.reserved.keyword.kwlist))


(defn hyghlight-builtins []
  (sorted
   (- (hy.core.reserved.names)
      (frozenset hy.core.reserved.keyword.kwlist))))


(defmacro replace-line [spaces line-format end-of-line keywords]
  `(+ line
      (.join ~end-of-line
             (list-comp
              (.format ~line-format
                       :space (* " " ~spaces)
                       :line (.join " " keyword-line))
              [keyword-line (partition ~keywords 10)]))
      "\n"))

(defn generate-highlight-js-file []
  (defn replace-highlight-js-keywords [line]
    (cond
     [(in "// keywords" line) (replace-line 6
                                            "{space}'{line} '"
                                            " +\n"
                                            (hyghlight-names))]
     [True line]))

  (with [f (open "templates/highlight_js/hy.js")]
        (.join ""
               (list-comp (replace-highlight-js-keywords line)
                          [line (.readlines f)]))))


(defn generate-rouge-file []
  (defn replace-rouge-keywords [line]
    (cond
     [(in "@keywords" line) (replace-line 10
                                          "{space}{line}"
                                          "\n"
                                          (hyghlight-keywords))]
     [(in "@builtins" line) (replace-line 10
                                          "{space}{line}"
                                          "\n"
                                          (hyghlight-builtins))]
     [True line]))

  (with [f (open "templates/rouge/hylang.rb")]
        (.join ""
               (list-comp (replace-rouge-keywords line)
                          [line (.readlines f)]))))


(defmain [&rest args]
  (let [highlight-library (second args)]
    (print (cond
            [(= highlight-library "highlight.js")
             (generate-highlight-js-file)]
            [(= highlight-library "rouge")
             (generate-rouge-file)]
            [True "Usage: hy hyghlight.hy [highlight.js | rouge]"]))))
