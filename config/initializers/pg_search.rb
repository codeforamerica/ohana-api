PgSearch.multisearch_options = {
  :using => {
    :tsearch => {:any_word => true},
    :dmetaphone => {:any_word => true},
    :trigram => {:threshold => 0.1}
  }
}
