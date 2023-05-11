(herald "GNAP User-Code Interaction using Channels")

(include "gnap_uci_channels_macros.lisp")

(defprotocol gnap_uci_channels basic
    ; CI
    (defrole client_instance
        (vars
            (ci rs name)
            (pk_ci pk_as akey)
            (as_cont_token_rand as_token_rand text)
            (eu_code code)
            (rs_access perm)
            (rs_data data)
            (ch_ci_as ch_ci_eu ch_ci_rs ch_as_ci ch_rs_ci chan)
        )
 
        (trace
            (ROLE_CI
                ci pk_ci ch_ci_as ch_ci_eu ch_ci_rs
                as_cont_token_rand as_token_rand pk_as ch_as_ci
                eu_code
                rs rs_access rs_data ch_rs_ci
            )
        )

        (uniq-orig rs_access)
        (non-orig (invk pk_ci) (invk pk_as))
        (auth ch_ci_eu ch_as_ci ch_rs_ci)
        (conf ch_ci_as ch_ci_eu ch_ci_rs ch_as_ci ch_rs_ci)
    )

    ; AS
    (defrole authorization_server
        (vars
            (ci as eu rs name)
            (pk_ci pk_as akey)
            (as_cont_token_rand as_token_rand eu_code_status text)
            (eu_code code)
            (rs_access perm)
            (ch_ci_as ch_as_ci ch_as_eu ch_eu_as chan)
        )

        (trace
            (ROLE_AS
                ci pk_ci ch_ci_as
                as as_cont_token_rand as_token_rand pk_as ch_as_ci ch_as_eu
                eu eu_code eu_code_status ch_eu_as
                rs rs_access
            )
        )

        (uniq-orig as_cont_token_rand as_token_rand eu_code eu_code_status)
        (non-orig (invk pk_ci) (invk pk_as) (ltk eu as))
        (auth ch_as_ci ch_eu_as)
        (conf ch_ci_as ch_as_ci ch_as_eu ch_eu_as)
    )

    ; EU
    (defrole end_user
        (vars
            (as eu name)
            (eu_code code)
            (eu_code_status data)
            (ch_ci_eu ch_as_eu ch_eu_as chan)
        )

        (trace
            (ROLE_EU
                ch_ci_eu
                as ch_as_eu
                eu eu_code eu_code_status ch_eu_as
            )
        )

        (non-orig (ltk as eu))
        (auth ch_ci_eu ch_as_eu)
        (conf ch_ci_eu ch_as_eu ch_eu_as)
    )

    ; RS
    (defrole resource_server
        (vars
            (ci rs name)
            (pk_ci pk_as akey)
            (as_token_rand text)
            (rs_access perm)
            (rs_data data)
            (ch_ci_rs ch_rs_ci chan)
        )

        (trace
            (ROLE_RS
                ci pk_ci ch_ci_rs
                as_token_rand pk_as
                rs rs_access rs_data ch_rs_ci
            )
        )

        (uniq-orig rs_data)
        (non-orig (invk pk_ci) (invk pk_as))
        (auth ch_rs_ci)
        (conf ch_ci_rs ch_rs_ci)
    )

    ; Custom Sorts
    (lang (perm atom))
    (lang (code atom))
)

(defskeleton gnap_uci_channels
    (vars)
    (defstrandmax client_instance)
)

(defskeleton gnap_uci_channels
    (vars)
    (defstrandmax authorization_server)
)

(defskeleton gnap_uci_channels
    (vars)
    (defstrandmax end_user)
)

(defskeleton gnap_uci_channels
    (vars)
    (defstrandmax resource_server)
)
