let sliderInner = document.querySelector(".slider--inner");

let images = 
sliderInner.querySelectorAll("img");
let index = 1;

setInterval(function(){
    let percentage = index * -100;
    sliderInner.style.transform = 
    "translateX("+ percentage + "%)";
    index++;
    if(index > (images.length)-1){
        index = 0;
    }
},3000)


let sliderInner1 = document.querySelector(".slider--inner1");

let images1 = 
sliderInner1.querySelectorAll("img");
let index1 = 1;

setInterval(function(){
    let percentage = index1 * -100;
    sliderInner1.style.transform = 
    "translateX("+ percentage + "%)";
    index1++;
    if(index1 > (images1.length)-1){
        index1 = 0;
    }
},3000)

let sliderInner2 = document.querySelector(".slider--inner2");

let images2 = 
sliderInner2.querySelectorAll("img");
let index2 = 1;

setInterval(function(){
    let percentage = index2 * -100;
    sliderInner2.style.transform = 
    "translateX("+ percentage + "%)";
    index2++;
    if(index2 > (images.length)-1){
        index2 = 0;
    }
},3000)

