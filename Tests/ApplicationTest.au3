#AutoIt3Wrapper_Run_AU3Check=N

#include <Array.au3>

#include "..\helpers.au3"

#include "..\au3pm\au3unit\Unit\assert.au3"
#include "..\Application.au3"
#include "..\CommandLoader\FactoryCommandLoader.au3"
#include "..\Tester\ApplicationTester.au3"

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
	assertEquals('Command', __au3Console_array_assoc_get($commands, 'help').__class, '->all() returns the registered commands')
	;assertInstanceOf('Symfony\\Component\\Console\\Command\\HelpCommand', $commands['help'], '->all() returns the registered commands');

	$application.add(FooCommand());
	$commands = $application.all('foo');
	assertEquals(1, UBound($commands, 1), '->all() takes a namespace as its first argument')
	;assertCount(1, $commands, '->all() takes a namespace as its first argument');
#testAllWithCommandLoader
	$application = Application();
	$commands = $application.all();
	assertEquals('Command', __au3Console_array_assoc_get($commands, 'help').__class, '->all() returns the registered commands')
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
	assertEquals('Command', __au3Console_array_assoc_get($commands, 'foo:bar').__class, '->all() returns the registered commands')
	;assertInstanceOf(\FooCommand::class, $commands['foo:bar'], '->all() returns the registered commands');
	assertEquals('Command', __au3Console_array_assoc_get($commands, 'foo:bar1').__class, '->all() returns the registered commands')
	;assertInstanceOf(\Foo1Command::class, $commands['foo:bar1'], '->all() returns the registered commands');
#testRegister
	$application = Application()
	$command = $application.register('foo')
	;assertEquals('foo', $command.getName(), '->register() registers a new command')
	assertEquals('Command', $command.getName(), '->register() registers a new command')
#testRegisterAmbiguous
	$code = Anonymous1601319278
	Func Anonymous1601319278($input, $output)
		$output.writeln('It works!')
	EndFunc

	Global $tmp = ['test']

	$application = Application()
	$application.setAutoExit(False)
	$application _
		.register('test-foo') _
		.setAliases($tmp) _
		.setCode($code)

	$application _
		.register('test-bar') _
		.setCode($code)

	Global $tmp = ['test']
	$tester = ApplicationTester($application)
	$tester.run($tmp)
	assertStringContainsString('it works!', $tester.getDisplay(True))
#testAdd
	$application = Application()
	$foo = FooCommand()
	$application.add($foo)
	$commands = $application.all()
	$this.assertEquals($foo, __au3Console_array_assoc_get($commands, 'foo:bar'), '->add() registers a command')

	$application = Application()
	Global $foo = FooCommand()
	Global $foo1 = Foo1Command()
	Global $tmp = [$foo, $foo1]
	$application.addCommands($tmp)
	$commands = $application->all()
	Global $tmp1 = [$foo, $foo1]
	Global $tmp2 = [__au3Console_array_assoc_get($commands, 'foo:bar'), __au3Console_array_assoc_get($commands, 'foo:bar1')]
	$this->assertEquals($tmp1, $tmp2, '->addCommands() registers an array of commands')
