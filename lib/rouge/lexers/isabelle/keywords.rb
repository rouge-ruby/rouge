module Rouge
  module Lexers
    class Isabelle
      KEYWORD_PSEUDO = Set.new %w(
        and assumes attach avoids binder checking
        class_instance class_relation code_module congs
        constant constrains datatypes defines file fixes
        for functions hints identifier if imports in
        includes infix infixl infixr is keywords lazy
        module_name monos morphisms no_discs_sels notes
        obtains open output overloaded parametric permissive
        pervasive rep_compat shows structure type_class
        type_constructor unchecked unsafe where

        apply apply_end apply_trace back defer prefer
      )

      KEYWORD_DIAG = Set.new %w(
        ML_command ML_val class_deps code_deps code_thms
        display_drafts find_consts find_theorems find_unused_assms
        full_prf help locale_deps nitpick pr prf
        print_abbrevs print_antiquotations print_attributes
        print_binds print_bnfs print_bundles
        print_case_translations print_cases print_claset
        print_classes print_codeproc print_codesetup
        print_coercions print_commands print_context
        print_defn_rules print_dependencies print_facts
        print_induct_rules print_inductives print_interps
        print_locale print_locales print_methods print_options
        print_orders print_quot_maps print_quotconsts
        print_quotients print_quotientsQ3 print_quotmapsQ3
        print_rules print_simpset print_state print_statement
        print_syntax print_theorems print_theory print_trans_rules
        prop pwd quickcheck refute sledgehammer smt_status
        solve_direct spark_status term thm thm_deps thy_deps
        try try0 typ unused_thms value values welcome
        print_ML_antiquotations print_term_bindings values_prolog
      )

      KEYWORD_SECTION = Set.new %w(header chapter)

      KEYWORD_SUBSECTION = Set.new %w(section subsection subsubsection sect subsect subsubsect)

      KEYWORD_THEORY = Set.new %w(
        ax_specification bnf code_pred corollary cpodef
        crunch crunch_ignore
        enriched_type function instance interpretation lemma
        lift_definition nominal_inductive nominal_inductive2
        nominal_primrec pcpodef primcorecursive
        quotient_definition quotient_type recdef_tc rep_datatype
        schematic_corollary schematic_lemma schematic_theorem
        spark_vc specification subclass sublocale termination
        theorem typedef wrap_free_constructors

        inductive_cases inductive_simps
      )

      KEYWORD_ABANDON_PROOF = Set.new %w(sorry oops)

      KEYWORDS = Set.new %w(
        theory begin end

        ML ML_file abbreviation adhoc_overloading arities
        atom_decl attribute_setup axiomatization bundle
        case_of_simps class classes classrel codatatype
        code_abort code_class code_const code_datatype
        code_identifier code_include code_instance code_modulename
        code_monad code_printing code_reflect code_reserved
        code_type coinductive coinductive_set consts context
        datatype datatype_new datatype_new_compat declaration
        declare default_sort defer_recdef definition defs
        domain domain_isomorphism domaindef equivariance
        export_code extract extract_type fixrec fun
        fun_cases hide_class hide_const hide_fact hide_type
        import_const_map import_file import_tptp import_type_map
        inductive inductive_set instantiation judgment lemmas
        lifting_forget lifting_update local_setup locale
        method_setup nitpick_params no_adhoc_overloading
        no_notation no_syntax no_translations no_type_notation
        nominal_datatype nonterminal notation notepad oracle
        overloading parse_ast_translation parse_translation
        partial_function primcorec primrec primrec_new
        print_ast_translation print_translation quickcheck_generator
        quickcheck_params realizability realizers recdef record
        refute_params setup setup_lifting simproc_setup
        simps_of_case sledgehammer_params spark_end spark_open
        spark_open_siv spark_open_vcg spark_proof_functions
        spark_types statespace syntax syntax_declaration text
        text_raw theorems translations type_notation
        type_synonym typed_print_translation typedecl hoarestate
        install_C_file install_C_types wpc_setup c_defs c_types
        memsafe SML_export SML_file SML_import approximate
        bnf_axiomatization cartouche datatype_compat
        free_constructors functor nominal_function
        nominal_termination permanent_interpretation
        binds defining smt2_status term_cartouche
        boogie_file text_cartouche

        by done qed

        have hence interpret

        next proof

        ML_prf also include including let moreover note
        txt txt_raw unfolding using write

        finally from then ultimately with

        assume case def fix presume

        guess obtain show thus
      )
    end
  end
end
