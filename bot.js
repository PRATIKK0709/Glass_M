const { Client } = require('discord.js-selfbot-v13');
const http = require('http');

const client = new Client();
const TARGET_USER = 'your_friends_token'; 


const logger = {
    info: (message) => console.log(`[${new Date().toLocaleTimeString()}] INFO: ${message}`),
    error: (message) => console.error(`[${new Date().toLocaleTimeString()}] ERROR: ${message}`)
};

client.on('ready', () => {
    logger.info(`Logged in as ${client.user.tag}!`);
    logger.info(`Monitoring DMs from user: ${TARGET_USER}`);
});

client.on('messageCreate', async msg => {
    try {
        if (msg.author.id === TARGET_USER && msg.channel.type === 'DM') {
            logger.info(`Received DM: ${msg.content}`);
            await sendToApp(msg.content);
        }
    } catch (error) {
        logger.error(`Message handling error: ${error.message}`);
    }
});

async function sendToApp(message) {
    return new Promise((resolve, reject) => {
        const postData = JSON.stringify({
            content: message,
            timestamp: new Date().toISOString()
        });

        const req = http.request({
            host: 'localhost',
            port: 8080,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(postData)
            }
        });

        req.on('response', (res) => {
            logger.info(`Message forwarded to app - Status: ${res.statusCode}`);
            resolve();
        });

        req.on('error', (error) => {
            logger.error(`Network error: ${error.message}`);
            reject(error);
        });

        req.write(postData);
        req.end();
    });
}

client.login('YOUR_TOKEM')
    .then(() => logger.info('Login successful'))
    .catch(error => logger.error(`Login failed: ${error.message}`));


process.on('SIGINT', () => {
    logger.info('Shutting down bot...');
    client.destroy();
    process.exit();
});
