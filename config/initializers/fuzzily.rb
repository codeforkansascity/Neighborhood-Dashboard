# Fuzzy Search has an issue where it can't connect it's methods to the rails 5 models.
ActiveRecord::Base.extend(Fuzzily::Searchable::Rails4ClassMethods)