PgSearch.multisearch_options = {
  :using => {
    :tsearch => {:prefix => true},
    :dmetaphone => {:any_word => true},
  }
}
