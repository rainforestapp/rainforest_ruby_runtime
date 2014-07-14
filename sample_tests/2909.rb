# Step 1
# Navigate to http://simonmathieu.com/
# A: Look at the page.
# Q: Do you see the words "I'm a software developer"?

visit "http://simonmathieu.com/"

page.should have_content("I'm a software developer")

# Step 2
# A: Looks at the page.
# Q: Do you see the word "reliability"?
 
page.should have_content("reliability")

# Step 3
# A: Look at the page.
# Q: Do you see the word "JavaScript"?

page.should have_content("JavaScript")
