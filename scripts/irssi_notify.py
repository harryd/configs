#!/usr/bin/python2
# A notify script for irssi on a remote server
from twisted.words.protocols import irc
from twisted.internet import reactor, protocol
import pynotify
import os
from cgi import escape as cgi_escape

try:
    pynotify.init("Markup")
except Exception, error:
    print "Failed to init python-notify 'Markup'"
    print error

class Notifier:
    def __init__(self):
        self.colors = {
             'normal':      '#FFFFFF',
             'query':       '#FF0044',
             'hilight':     '#9393DD',
             'disconnect':  '#CC9393',
             'connect':     '#7F9F7F'
             }
        self.on=True
        pass
    def sanitize(self, str):
        return cgi_escape(str)

    def notify(self, channel, message, type='normal', time=4):
        notification = pynotify.Notification(
                '<span color=\'%s\'>%s</span>\n%s' %
                (self.colors[type], channel, self.sanitize(self.trim(message,50))), '')
        notification.set_timeout(time*1000)
        notification.show()

    def notify_on(self):
        self.on=True

    def notify_off(self):
        self.on=False
        
    def trim(self, str, length):
        if len(str) > length:
            return str[:length-3] + '...'
        else:
            return str + (' ' * (length - len(str)))

class IRCBot(irc.IRCClient):
    '''A logging IRC bot.'''
    
    nickname = 'tb'
    password = os.environ['IRSSIPASS']
    nick =     os.environ['IRSSINICK']

    def connectionMade(self):
        irc.IRCClient.connectionMade(self)
        self.n = self.factory.notifyer
    
    def connectionLost(self, reason):
        irc.IRCClient.connectionLost(self, reason)

    def signedOn(self):
        '''Called when bot has succesfully signed on to server.'''
        self.n.notify('Connected', 'You are connected to the server')

    def privmsg(self, user, channel, msg):
        '''This will get called when the bot receives a message.'''
        user = user.split('!', 1)[0]
        if msg.lower().find(self.nick.lower()) != -1:
            self.n.notify(channel, '< %s> %s' % (user, msg), 'hilight', 0)
        elif channel == self.nick:
            self.n.notify(user, '%s' % msg, 'query', 0)
        else:
            self.n.notify(channel, '< %s> %s' % (user, msg))

    def action(self, user, channel, msg):
        '''This will get called when the bot sees someone do an action.'''
        user = user.split('!', 1)[0]
    # irc callbacks

    def irc_NICK(self, prefix, params):
        '''Called when an IRC user changes their nickname.'''
        old_nick = prefix.split('!')[0]
        new_nick = params[0]

    def irc_QUIT(self, prefix, params):
        nick = prefix.split('!')[0]
        self.n.notify('Disconnected:', nick, 'disconnect', 3)

    def irc_JOIN(self, prefix, params):
        nick = prefix.split('!')[0]
        self.n.notify('Connected:', nick, 'connect', 3)

    def irc_PART(self, prefix, params):
        nick = prefix.split('!')[0]
        self.n.notify('Disconnected:', nick, 'disconnect', 3)

#    def lineReceived(self, line):
#        print line

    # For fun, override the method that determines how a nickname is changed on
    # collisions. The default method appends an underscore.
    def alterCollidedNick(self, nickname):
        '''
        Generate an altered version of a nickname that caused a collision in an
        effort to create an unused related name for subsequent registration.
        '''
        return nickname + '^'



class IRCBotFactory(protocol.ClientFactory):
    '''A factory for LogBots.

    A new protocol instance will be created each time we connect to the server.
    '''

    # the class of the protocol to build when new connection is made
    protocol = IRCBot
    
    def __init__(self, password, nick, notifyer):
        self.notifyer = notifyer
    def clientConnectionLost(self, connector, reason):
        '''If we get disconnected, reconnect to server.'''
        connector.connect()

    def clientConnectionFailed(self, connector, reason):
        print 'connection failed:', reason
        reactor.stop()


if __name__ == '__main__':
    # initialize logging
    n = Notifier() 
    for i in range(2776, 2780):
        # create factory protocol and application
        f = IRCBotFactory('', '', n)
        # connect factory to this host and port
        reactor.connectTCP('harry.is', i, f)

    # run bot
    reactor.run()
