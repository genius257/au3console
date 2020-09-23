#AutoIt3Wrapper_Run_AU3Check=N

#include <Array.au3>

#include "..\au3pm\au3unit\Unit\assert.au3"
#include "..\Application.au3"
#include "..\CommandLoader\FactoryCommandLoader.au3"

#include ".\Fixtures\FooCommand.au3"
#include ".\Fixtures\Foo1Command.au3"

#testSetGetName
	$application = Application();
	$application.setName('foo');
	assertEquals('foo', $application.getName(), '->setName() sets the name of the application');
#testSetGetVersion
	$application = Application();
	$application.setVersion('bar');
	assertEquals('bar', $application.getVersion(), '->setVersion() sets the version of the application');
#testGetLongVersion
	$application = Application('foo', 'bar');
	assertEquals('foo <info>bar</info>', $application.getLongVersion(), '->getLongVersion() returns the long version of the application');
#testHelp
	$application = Application();
	;assertStringEqualsFile($fixturesPath&'/application_gethelp.txt', normalizeLineBreaks($application.getHelp()), '->getHelp() returns a help message');
#testAll
	$application = Application();
	$commands = $application.all();
	;_ArrayDisplay($commands)
	;assertInstanceOf('Symfony\\Component\\Console\\Command\\HelpCommand', $commands['help'], '->all() returns the registered commands');

	$application.add(FooCommand());
	$commands = $application.all('foo');
	assertEquals(1, UBound($commands, 1), '->all() takes a namespace as its first argument')
	;assertCount(1, $commands, '->all() takes a namespace as its first argument');
#testAllWithCommandLoader
	$application = Application();
	$commands = $application.all();
	;assertInstanceOf('Symfony\\Component\\Console\\Command\\HelpCommand', $commands['help'], '->all() returns the registered commands');

	$application.add(FooCommand());
	$commands = $application.all('foo');
	assertEquals(1, UBound($commands, 1), '->all() takes a namespace as its first argument')
	;assertCount(1, $commands, '->all() takes a namespace as its first argument');

	Func Anonymous1600804942()
		Return Foo1Command()
	EndFunc

	Global $tmp = [['foo:bar1', Anonymous1600804942]]

	$application.setCommandLoader(FactoryCommandLoader($tmp));
	$commands = $application.all('foo');
	assertEquals(2, UBound($commands, 1), '->all() takes a namespace as its first argument')
	;assertCount(2, $commands, '->all() takes a namespace as its first argument');
	;assertInstanceOf(\FooCommand::class, $commands['foo:bar'], '->all() returns the registered commands');
	;assertInstanceOf(\Foo1Command::class, $commands['foo:bar1'], '->all() returns the registered commands');
#
