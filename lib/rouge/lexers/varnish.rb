# -*- coding: utf-8 -*- #

module Rouge
    module Lexers
        class Varnish < RegexLexer
            aliases 'varnishconf', 'VCL'
            title 'Varnish'
            desc 'The Varnish (high-performance web accelerator) configuration language'
            tag 'varnish'
            filenames '*.vcl'
            mimetypes 'text/x-varnish'

            LNUM = '[0-9]+'
            DNUM = '([0-9]*"."[0-9]+)|([0-9]+"."[0-9]*)'
            SPACE = '[ \f\n\r\t\v]+'
#             IDENT1 = [a-zA-Z]
#             IDENT = IDENT1 | [0-9_-]
#             VAR = IDENT | '.'

            # backend acl
            KEYWORDS = Set.new %w[vcl set unset include import if else elseif elif elsif]

            BUILTIN_FUNCTIONS = Set.new %w[
                ban
                call
                hash_data
                new
                regsub
                regsuball
                return
                rollback
                std.cache_req_body
                std.collect
                std.duration
                std.fileread
                std.healthy
                std.integer
                std.ip
                std.log
                std.port
                std.querysort
                std.random
                std.real
                std.real2time
                std.rollback
                std.set_ip_tos
                std.strstr
                std.syslog
                std.time
                std.time2integer
                std.time2real
                std.timestamp
                std.tolower
                std.toupper
                synth
                synthetic
            ]

            BUILTIN_VARIABLES = Set.new %w[
                bereq
                bereq.backend
                bereq.between_bytes_timeout
                bereq.connect_timeout
                bereq.first_byte_timeout
                bereq.method
                bereq.proto
                bereq.retries
                bereq.uncacheable
                bereq.url
                bereq.xid
                beresp
                beresp.age
                beresp.backend
                beresp.backend.ip
                beresp.backend.name
                beresp.do_esi
                beresp.do_gunzip
                beresp.do_gzip
                beresp.do_stream
                beresp.grace
                beresp.keep
                beresp.proto
                beresp.reason
                beresp.status
                beresp.storage_hint
                beresp.ttl
                beresp.uncacheable
                beresp.was_304
                client.identity
                client.ip
                local.ip
                now
                obj.age
                obj.grace
                obj.hits
                obj.keep
                obj.proto
                obj.reason
                obj.status
                obj.ttl
                obj.uncacheable
                remote.ip
                req
                req.backend_hint
                req.can_gzip
                req.esi
                req.esi_level
                req.hash_always_miss
                req.hash_ignore_busy
                req.method
                req.proto
                req.restarts
                req.ttl
                req.url
                req.xid
                resp
                resp.proto
                resp.reason
                resp.status
                server.hostname
                server.identity
                server.ip
            ]

            BUILTIN_ROUTINES = Set.new %w[
                backend_error
                backend_fetch
                backend_response
                purge
                deliver
                fini
                hash
                hit
                init
                miss
                pass
                pipe
                recv
                synth
            ]

            STATES_MAP = {
                :root => Text,
                :string => Str::Double,
            }

            state :default do
                rule /\r\n?|\n/ do
                    token STATES_MAP[state.name.to_sym]
                end
                rule /./ do
                    token STATES_MAP[state.name.to_sym]
                end
            end

            state :root do
                # long strings ({" ... "})
                rule %r'\{".*?"}'m, Str::Single

                # comments
                rule %r'/\*.*?\*/'m, Comment::Multiline
                rule %r'(?://|#).*', Comment::Single

                rule /true|false/, Keyword::Constant

                # "wildcard variables"
                rule /(?:(?:be)?re(?:sp|q)|obj)\.http\.[a-zA-Z0-9_.-]+/ do
                    token Name::Variable
                end

                rule /(sub)(#{SPACE})([a-zA-Z0-9_-]+)/ do
                    groups Keyword, Text, Name::Function
                end

                # inline C (C{ ... }C)
                rule /C\{/ do
                    token Comment::Preproc
                    push :inline_c
                end

                rule /[a-zA-Z_.-]+/ do |m|
                    next token Keyword if KEYWORDS.include? m[0]
                    next token Name::Function if BUILTIN_FUNCTIONS.include? m[0]
                    next token Name::Variable if BUILTIN_VARIABLES.include? m[0]
                    token Text
                end

                # duration
                rule /(?:#{LNUM}|#{DNUM})(?:ms|[smhdwy])/, Literal::Number::Other
                # size in bytes
                rule /#{LNUM}[KMGT]?B/, Literal::Number::Other
                # literal numeric values (integer/float)
                rule /#{LNUM}/, Num::Integer
                rule /#{DNUM}/, Num::Float

                # standard strings
                rule /"/ do |m|
                    token Str::Double
                    push :string
                end

                rule %r'[&|+-]{2}|[<=>!*/+-]=|<<|>>|!~|[-+*/%><=!&|~]', Operator

                rule /[{}();.,]/, Punctuation

                mixin :default
            end

            state :string do
                rule /"/, Str::Double, :pop!
                rule /\\[\\"nt]/, Str::Escape

                mixin :default
            end

            state :inline_c do
                rule /}C/, Comment::Preproc, :pop!
                rule /.*?(?=}C)/m do
                    delegate C
                end
            end
        end
    end
end
