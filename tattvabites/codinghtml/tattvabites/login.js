document.querySelector(".login-container form").addEventListener("submit", function(e) {
    e.preventDefault();

    // Get login input values
    const username = document.getElementById('login-username').value;
    const password = document.getElementById('login-password').value;

    // Retrieve stored user data from localStorage
    const users = JSON.parse(localStorage.getItem("users")) || [];
    const user = users.find(user => user.username === username && user.password === password);

    if (user) {
        // Store user information in sessionStorage to persist login state
        sessionStorage.setItem("loggedInUser", JSON.stringify(user));
        window.location.href = "Home.html";  // Redirect to homepage after login
    } else {
        alert("Invalid username or password!");
    }
});
