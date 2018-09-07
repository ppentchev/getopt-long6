use v6;

use Test;

use Getopt::Long;

my $capture = Getopt::Long.new('foo|f|fooo=s@', 'bar', 'a', 'c').get-options(<--foo bar --fooo bar2 -f bar3 -ac --bar baz>);
is-deeply($capture, \('baz', :bar, :a, :c, :foo(Array[Str].new(<bar bar2 bar3>))), 'Common argument mix works');

multi main(*@, Str :fooo(:f(:@foo)), Bool :$bar) {
}
multi main(*@, Bool :$a!, Bool :$c!) {
}
my $getopt = Getopt::Long.new(&main);

my $capture2 = $getopt.get-options(<--foo bar --fooo bar2 --bar baz>);
is-deeply($capture2, \('baz', :bar, :foo(Array[Str].new(<bar bar2>))), 'Common argument mix works (2)');
lives-ok( { main(|$capture2) }, 'Calling main (1) works');

my $capture3 = $getopt.get-options(<-ac -fbar3>);
is-deeply($capture3, \(:a, :c, :foo(Array[Str].new(<bar3>))), 'Short options work');

my $capture4 = $getopt.get-options(<--foo bar --fooo bar2 -f bar3 -ac --bar baz>);
dies-ok( { main(|$capture4) }, 'Calling main (1) works');

my $capture5 = $getopt.get-options(<--bar -- -a>);
is-deeply($capture5, \('-a', :bar), '"--" terminates argument handling');

my $capture6 = Getopt::Long.new('quz=f').get-options([<--quz=2.5>]);
is-deeply($capture6, \(:quz(2.5)), 'Numeric arguments work');

my $getopt2 = Getopt::Long.new('quz:i');

my $capture7 = $getopt2.get-options(['--quz']);
is-deeply($capture7, \(:quz(0)), ':i without argument works');

my $capture8 = $getopt2.get-options(<--quz 2>);
is-deeply($capture8, \(:quz(2)), ':i with argument works');

my $getopt3 = Getopt::Long.new('quz:1');

my $capture9 = $getopt3.get-options(['--quz']);
is-deeply($capture9, \(:quz(1)), ':1 without argument works');

my $capture10 = $getopt3.get-options(<--quz 2>);
is-deeply($capture10, \(:quz(2)), ':1 with argument works');

my $getopt4 = Getopt::Long.new('foo+');

my $capture11 = $getopt4.get-options(<--foo --foo>);
is-deeply($capture11, \(:foo(2)), 'Counter adds up');

my $getopt5 = Getopt::Long.new('foo:+');

my $capture12 = $getopt5.get-options(['--foo']);
is-deeply($capture12, \(:foo(1)), 'Colon singles fine');

my $capture13 = $getopt5.get-options(<--foo 2 --foo>);
is-deeply($capture13, \(:foo(3)), 'Colon counter adds up');

my $getopt6 = Getopt::Long.new('bar=o');

my $capture14 = $getopt6.get-options(<--bar 012>);
is-deeply($capture14, \(:bar(10)), 'Parsing octal argument with "o"');

my $capture15 = $getopt6.get-options(<--bar -012>);
is-deeply($capture15, \(:bar(-10)), 'Parsing negative octal argument with "o"');

my $capture16 = $getopt6.get-options(<--bar 12>);
is-deeply($capture16, \(:bar(12)), 'Parsing decimal argument with "o"');

done-testing;
