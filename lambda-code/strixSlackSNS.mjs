export const handler = async (event) => {
    const snsMessage = event.Records[0].Sns.Message;

    const slackPayload = {
        text: snsMessage
    };

    // POST towards the slack webhook
    const response = await fetch(process.env.SLACK_WEBHOOK_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(slackPayload)
    });

    console.log("slack response:", response.status);
    return { statusCode: 200 };
};
