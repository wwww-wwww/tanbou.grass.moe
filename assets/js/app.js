import "phoenix_html"

collection_view_back.addEventListener("click", e => {
  collection_view_back.style.display = "none"
  collection_view.style.display = "none"
})
collection_view.addEventListener("click", e => {
  if (e.target != collection_view && e.target.tagName != "IMG")
    return
  collection_view_back.style.display = "none"
  collection_view.style.display = "none"
})

Array.from(document.getElementsByClassName("collection")).forEach((el) => {
  el.addEventListener("click", e => {
    collection_view_back.style.display = "block"
    collection_view.style.display = "flex"

    const images = [...el.children[0].children].map(e => e.children[0])

    for (let i = 0; i < 4; i++) {
      collection_view_labels.children[i].style.display = "none"
    }

    for (let i = 0; i < images.length; i++) {
      collection_view_images.children[i].src = images[i].src
      requestAnimationFrame(() =>
        collection_view_images.children[i].src = images[i].getAttribute("fullsize")
      )
      collection_view_labels.children[i].style.display = "unset"
    }

    let index = 0
    if (e.target.tagName == "IMG") {
      index = images.findIndex(v => v.src == e.target.src)
    }

    Array.from(collection_view.children[0].children)
      .filter(e => e.tagName == "INPUT")[index].checked = true

    const last = images[index].getBoundingClientRect()
    const first = collection_view_images.children[index].getBoundingClientRect()
    const sx = last.width / first.width
    const sy = last.height / first.height
    const dx = last.left - first.left * sx
    const dy = last.top - first.top * sy

    collection_view.animate([{
      transformOrigin: "top left",
      transform: `translate(${dx}px, ${dy}px) scale(${sx},${sy})`,
      opacity: 0
    }, {
      transformOrigin: "top left",
      transform: "none",
      opacity: 1
    }], {
      duration: 200,
      easing: "ease-out",
      fill: "both"
    })


    collection_view_back.animate([{
      opacity: 0
    }, {
      opacity: 1
    }], {
      duration: 100,
      easing: "ease-out",
      fill: "both"
    })
  })
})
