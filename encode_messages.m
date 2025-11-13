
function encoded = encode_messages(messages, G, A)
    encoded = mod(messages * G(A+1,:), 2);
end