(herald "GNAP Software-only Authorization using Channels")

(include "gnap_soa_channels_macros.lisp")

(defprotocol gnap_soa_channels basic
    ; CI
    (defrole client_instance
        (vars
            (ci rs name)
            (as_token_rand rand)
            (rs_access access)
            (rs_data data)
            (ci_key pk_as akey)
            (ch_ci_as ch_ci_rs ch_as_ci ch_rs_ci chan)
        )

        (trace
            (ROLE_CI
                ci ci_key ch_ci_as ch_ci_rs
                as_token_rand pk_as ch_as_ci
                rs rs_access rs_data ch_rs_ci
            )
        )

        (uniq-orig ci_key)
        (auth ch_ci_as ch_ci_rs ch_as_ci ch_rs_ci)
        (conf ch_ci_as ch_ci_rs ch_as_ci ch_rs_ci)
    )

    ; AS
    (defrole authorization_server
        (vars
            (ci rs name)
            (as_token_rand rand)
            (rs_access access)
            (ci_key pk_as akey)
            (ch_ci_as ch_as_ci chan)
        )

        (trace
            (ROLE_AS
                ci ci_key ch_ci_as
                as_token_rand pk_as ch_as_ci
                rs rs_access
            )
        )

        (uniq-orig as_token_rand)
        (non-orig (invk pk_as))
        (auth ch_ci_as ch_as_ci)
        (conf ch_ci_as ch_as_ci)
    )

    ; RS
    (defrole resource_server
        (vars
            (ci rs name)
            (as_token_rand rand)
            (ci_key pk_as akey)
            (rs_access access)
            (rs_data data)
            (ch_ci_rs ch_rs_ci chan)
        )

        (trace
            (ROLE_RS
                ci ci_key ch_ci_rs
                as_token_rand pk_as
                rs rs_access rs_data ch_rs_ci
            )
        )

        (uniq-orig rs_data)
        (auth ch_ci_rs ch_rs_ci)
        (conf ch_ci_rs ch_rs_ci)
    )

    ; Custom Sorts
    (lang (access atom))
    (lang (rand atom))
)

(defskeleton gnap_soa_channels
    (vars)
    (defstrandmax client_instance)
)

(defskeleton gnap_soa_channels
    (vars)
    (defstrandmax authorization_server)
)

(defskeleton gnap_soa_channels
    (vars)
    (defstrandmax resource_server)
)
