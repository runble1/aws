import { DynamoDB } from 'aws-sdk';
import { Context, Callback } from 'aws-lambda';

console.log('Loading read function');

const DYNAMODB_TABLE_NAME = process.env.DYNAMODB_TABLE_NAME || '';

const docClient = new DynamoDB.DocumentClient();

export const handler = (event: any, context: Context, callback: Callback) => {
    console.log('Received event:', JSON.stringify(event, null, 2));

    const params = {
        // TODO: 作成したDynamoDBテーブルの名前に書き換えてください
        TableName: DYNAMODB_TABLE_NAME,
        KeyConditionExpression: 'Artist = :artist',
        ExpressionAttributeValues: {
            ':artist': event.artist
        }
    };

    docClient.query(params, (err, data) => {
        if (err) {
            console.log('Error', err);
            callback(Error(err.message));
        } else {
            console.log('Success', data);
            callback(null, data.Items);
        }
    });
};
