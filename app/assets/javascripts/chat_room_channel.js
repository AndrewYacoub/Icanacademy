import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const chatRoomElement = document.getElementById('chat_room_id');
  if (chatRoomElement) {
    const chatRoomId = chatRoomElement.getAttribute('data-chat-room-id');

    consumer.subscriptions.create({ channel: "ChatRoomChannel", chat_room_id: chatRoomId }, {
      connected() {
        console.log('Connected to the chat room!');
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        const messagesContainer = document.getElementById('messages');
        messagesContainer.innerHTML += data.message;
      },

      send_message(message) {
        this.perform('send_message', { message: message, chat_room_id: chatRoomId });
      }
    });

    const messageForm = document.getElementById('new_message');
    messageForm.addEventListener('submit', (event) => {
      event.preventDefault();
      const messageInput = messageForm.querySelector('#message_content');
      const message = messageInput.value;
      const subscription = consumer.subscriptions.subscriptions[0];
      subscription.send_message(message);
      messageInput.value = '';
    });
  }
});
