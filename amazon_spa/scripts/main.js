const BASE_URL = 'http://localhost:3000/api/v1'

const Session = {
    create(params) {
        return fetch(`${BASE_URL}/session`, {
            method: 'POST',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(params)
        }).then(res => {
            res.json()
        })
    }
}

const Product = {
    all() {
        return fetch(`${BASE_URL}/products`, {
            credentials: 'include'
        }).then(res => res.json())
    },
    show(id) {
        return fetch(`${BASE_URL}/products/${id}`, {
            credentials: 'include'
        }).then(res => res.json());
    },
    create(params) {
        return fetch(`${BASE_URL}/products`, {
            method: 'POST',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({product: params}) // or JSON.stringify(params)
        }).then(res => res.json())
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const index = document.querySelector('.product-list');
    const show = document.querySelector('#product-show');
    const navBar = document.querySelector('header nav')
    const newProduct = document.querySelector('#new-product-form')

    Product.all().then(products => {
        index.innerHTML = productList(products)
    })

    index.addEventListener('click', event => {
        const productLinkNode = event.target.closest('a')
        event.preventDefault()
        if (productLinkNode) {
            const productId = productLinkNode.getAttribute('data-id');
            Product.show(productId).then(product => {
                show.innerHTML = productShow(product)
                navigateTo('product-show')
            })
        }
    })

    navBar.addEventListener('click', event => {
        const navLink = event.target.closest('a');
        if (navLink) {
            event.preventDefault();
            navigateTo(navLink.getAttribute('data-target'))
        }
    })

    newProduct.addEventListener('submit', event => {
        event.preventDefault(); // because its an SPA it will refresh the page without .preventDefault();
        const {currentTarget} = event;
        const formData = new FormData(currentTarget);
        Product.create({
            title: formData.get('title'),
            description: formData.get('description'),
            price: formData.get('price'),
        }).then(({id}) => {
            Product.show(id).then(product => {
                show.innerHTML = productShow(product)
                navigateTo('product-show')
            })
        })
        
    })
})

function productList(products) {
    return products.map((product) => {
        return(`
            <a class="product-link" data-id=${product.id} href=""><h1>${product.title}</h1></a>
        `)
    }).join('')
}

function productShow(product) {
    return(`
        <h1>${product.title}</h1>
        <p>${product.description}</p>
        <p>Price: ${product.price}</p>
        <small>Posted by: ${product.seller.full_name}</small>
        <h3>Reviews</h3>
        ${reviewShow(product.reviews)}
    `)
}

function reviewShow(reviews) {
    return reviews.map(review => {
        return(`
            <li>${review.body}</li>
        `)
    }).join('')
}

function navigateTo(pageId) {
    document.querySelectorAll('.product.selected').forEach(node => {
        node.classList.remove('selected')
    })
    document.querySelector(`.product#${pageId}`).classList.add('selected')
}
