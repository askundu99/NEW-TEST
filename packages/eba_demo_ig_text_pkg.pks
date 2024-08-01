--
-- Package_Spec "EBA_DEMO_IG_TEXT_PKG"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "XX_TANGO"."EBA_DEMO_IG_TEXT_PKG" authid current_user is
    function text_is_available return boolean;
    procedure create_text_preferences;
    procedure drop_text_preferences;
    procedure create_text_index;
    procedure drop_text_index;
    procedure init_oracle_text;
    function convert_text_query( p_enduser_query in varchar2 ) return varchar2;
end eba_demo_ig_text_pkg;
/