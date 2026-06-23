import base64

# 1. Read a line of text from user input
text_input = input("Enter text to reverse and encode: ")

# 2. Reverse the character sequence
reversed_text = text_input[::-1]

# 3. Convert to bytes (required for base64 encoding)
reversed_bytes = reversed_text.encode('utf-8')

# 4. Encode to Base64
base64_encoded = base64.b64encode(reversed_bytes)

# 5. Convert bytes back to string for display
base64_string = base64_encoded.decode('utf-8')

print(f"Original: {text_input}")
print(f"Reversed: {reversed_text}")
print(f"Base64:   {base64_string}")


#Enter text to reverse and encode: b638f6e60bef8b3987e4114af1c8d6ca4f382400
#Original: b638f6e60bef8b3987e4114af1c8d6ca4f382400
#Reversed: 004283f4ac6d8c1fa4114e7893b8feb06e6f836b
#Base64:   MDA0MjgzZjRhYzZkOGMxZmE0MTE0ZTc4OTNiOGZlYjA2ZTZmODM2Yg==