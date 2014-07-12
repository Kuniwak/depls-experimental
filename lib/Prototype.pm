package Prototype;
use 5.014;
use warnings;
use utf8;

use AI::Prolog;
use Data::Dumper;

my $database = << 'END_PROLOG';
    depends_to(Dependent, Depended) :-
        is_alias_or_just_entity_of(DependentEntity, Dependent),
        is_alias_or_just_entity_of(DependedEntity, Depended),
        depends_directly_to(DependentEntity, DependedEntity).

    depends_to(Dependent, Depended) :-
        depends_directly_to(Dependent, InterDependent),
        depends_to(InterDependent, Depended).

    is_depended_by_just_entity(Depended, Dependent) :-
        depends_to(Dependent, Depended),
        is_entity(Dependent).

    is_alias(Any) :- alias_of(Any, _).
    is_entity(Any) :- not(is_alias(Any)).

    is_alias_or_just_entity_of(Alias, Aliased) :-
        alias_of(Alias, Aliased).
    is_alias_or_just_entity_of(JustEntity, JustEntity).

    alias_of(Alias, Aliased) :-
        alias_directly_of(Alias, Aliased).
    alias_of(Alias, Entity) :-
        alias_directly_of(Alias, InterAlias),
        alias_of(InterAlias, Entity), is_entity(Entity).

    depends_directly_to(root_1, node_1).
    depends_directly_to(root_2, node_1).
    depends_directly_to(root_1, node_2).
    depends_directly_to(node_1, node_1_1).
    depends_directly_to(node_1, node_1_2).
    depends_directly_to(node_2, node_2_1).
    alias_directly_of(alias_1, root1).
END_PROLOG

my $prolog = AI::Prolog->new($database);
$prolog->query('is_depended_by_just_entity(node_1, X).');
while (my $result = $prolog->results) {
    print Dumper $result->[2];
}

1;
