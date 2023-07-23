var acceptModalYes = document.getElementById("acceptModalYes");
var acceptModalNo = document.getElementById("acceptModalNo");

acceptModalYes.addEventListener("click", () => {
    console.log("Accept prompt, continue");
    $("#acceptModal").modal("hide");
    window.location = `${window._globals.urls.root_url}/about`;
});