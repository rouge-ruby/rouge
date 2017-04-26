# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class OpenMP < RegexLexer
      title "OpenMP"
      desc "OpenMP 4.5 (to be used with Fortran or C lexer)"

      name = /[A-Z][_A-Z]*/i

      def self.directives
        @directives ||= Set.new %w(
          end parallel do sections single workshare simd declare task taskloop
          taskyield target data enter exit update teams distribute master
          critical barrier taskwait taskgroup atomic flush ordered cancel
          cancellation point threadprivate reduction
        )
      end

      def self.clauses
        @clauses ||= Set.new %w(
          if depend default shared private firstprivate lastprivate linear
          reduction safelen collapse simdlen aligned uniform inbranch
          notinbranch copyin copyprivate map defaultmap final mergeable priority
          grainsize num_tasks
        )
      end

      def self.runtimeroutines
        @runtimeroutines ||= Set.new %w(
          omp_get_num_threads omp_set_num_threads omp_get_max_threads
          omp_get_thread_num omp_get_num_procs omp_in_parallel omp_set_dynamic
          omp_get_dynamic omp_get_cancellation omp_set_nested omp_get_nested
          omp_set_schedule omp_get_schedule omp_get_thread_limit
          omp_set_max_active_levels omp_get_level omp_get_ancestor_thread_num
          omp_get_team_size omp_get_active_level omp_in_final omp_get_proc_bind
          omp_get_num_places omp_get_place_num_procs omp_get_place_proc_ids
          omp_get_plane_num omp_get_partition_num_places
          omp_get_partition_place_nums omp_set_default_device
          omp_get_default_device omp_get_num_devices omp_get_num_teams
          omp_get_team_num omp_is_initial_device omp_get_initial_device
          omp_get_max_task_priority omp_init_lock omp_init_nest_lock
          omp_init_lock_with_hint omp_init_nest_lock_with_hint omp_destroy_lock
          omp_destroy_nest_lock omp_set_lock omp_set_nest_lock omp_unset_lock
          omp_unset_nest_lock omp_test_lock omp_test_nest_lock omp_get_wtime
          omp_get_wtick
        )
      end

      state :root do
        rule /[+-]?\d+/i, Num
        rule /[,\(\):><\[\]-]/, Punctuation
        rule /\s/, Text::Whitespace

        rule /#{name}/m do |m|
          match = m[0].downcase

          if self.class.directives.include? match
            token Name::Decorator
          elsif self.class.clauses.include? match
            token Name::Attribute
          else
            token Name
          end
        end
      end
    end
  end
end
