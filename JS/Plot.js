class ScanningPlot {
    constructor(parent, len, color, dots = false) {
        this.len = len;
        this.color = color;
        this.svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        this.svg.setAttribute("height", 200);
        this.svg.setAttribute("viewBox", `0 0 ${parent.clientWidth} ${parent.clientHeight}`);
        this.svg.setAttribute("preserveAspectRatio", "none");
        this.step = parent.clientWidth / this.len;
        this.height = parent.clientHeight;
        parent.appendChild(this.svg);

        this.circles = Array();
        this.filledC = 0;
        this.indexC = 0;
        this.dots = dots;

        this.lines = Array();
        this.filledL = 0;
        this.indexL = 0;
        this.previousValue = 0;
        this.previousIndex = len - 2;
        console.log(this);
    }

    add(value) {
        value = 1 - value;
        value *= this.height;
        this.addValueL(value);
        if (this.dots === true) {
            this.addValueC(value);
        }
    }

    addValueC(value) {
        if (this.filledC < this.len) {
            let circle = this.createCircle(this.step * this.filledC, value);
            this.svg.appendChild(circle);
            this.circles.push(circle);
            this.filledC++;
        } else {
            this.circles[this.indexC++].setAttribute("cy", value);
            this.indexC %= this.len;
        }
    }
    addValueL(value) {
        if (this.filledL < this.len) {
            if (this.filledL != 0) {
                let line = this.createLine(this.step * (this.filledL - 1), this.previousValue,
                    this.step * this.filledL, value);
                this.svg.appendChild(line);
                this.lines.push(line);
            }
            this.previousValue = value;
            this.filledL++;
        } else {
            if (this.indexL != this.len - 1) {
                this.lines[this.indexL].setAttribute("y1", value);
                this.lines[this.indexL].setAttribute("stroke", "none");
            }
            if (this.indexL != 0) {
                this.lines[this.previousIndex].setAttribute("y2", value);
                this.lines[this.previousIndex].setAttribute("stroke", this.color);
            }
            this.previousIndex = this.indexL;
            this.indexL++;
            this.indexL %= this.len;
        }
    }

    createCircle(x, y) {
        let circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
        circle.setAttribute("cx", x);
        circle.setAttribute("cy", y);
        circle.setAttribute("r", 2);
        circle.setAttribute("fill", this.color);
        return circle;
    }
    createLine(x1, y1, x2, y2) {
        let line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", x1);
        line.setAttribute("y1", y1);
        line.setAttribute("x2", x2);
        line.setAttribute("y2", y2);
        line.setAttribute("stroke", this.color);
        return line;
    }
};

class MovingPlot {
    constructor(parent, len, color, dots = false) {
        this.len = len;
        this.color = color;
        this.svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        this.svg.setAttribute("height", 200);
        this.svg.setAttribute("viewBox", `0 0 ${parent.clientWidth} ${parent.clientHeight}`);
        this.svg.setAttribute("preserveAspectRatio", "none");
        this.width = parent.clientWidth;
        this.step = parent.clientWidth / this.len;
        this.height = parent.clientHeight;
        this.dots = dots;
        parent.appendChild(this.svg);

        this.g1 = document.createElementNS("http://www.w3.org/2000/svg", "g");
        this.g2 = document.createElementNS("http://www.w3.org/2000/svg", "g");
        this.svg.appendChild(this.g1);
        this.svg.appendChild(this.g2);
        this.counter = 0;

        this.previousValue = this.height;
    }

    add(value) {
        value = 1 - value;
        value *= this.height;

        if (this.counter == this.len) {
            while (this.g2.firstChild) {
                this.g2.removeChild(this.g2.firstChild);
            }
            let tmp = this.g2;
            this.g2 = this.g1;
            this.g1 = tmp;
            this.counter = 0;
        }

        this.addValueL(value);
        if (this.dots === true) {
            this.addValueC(value);
        }


        this.g1.setAttribute("transform", `translate(${-this.step * this.counter + this.width})`);
        this.g2.setAttribute("transform", `translate(${-this.step * this.counter})`);
        this.counter++;


    }

    addValueC(value) {
        let circle = this.createCircle(this.step * this.counter, value);
        this.g1.appendChild(circle);
    }
    addValueL(value) {
        //if (this.counter !== 0) {
            let line = this.createLine((this.counter - 1) * this.step, this.previousValue, this.counter * this.step, value);
            this.g1.appendChild(line);            
        //}
        this.previousValue = value;
    }

    createCircle(x, y) {
        let circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
        circle.setAttribute("cx", x);
        circle.setAttribute("cy", y);
        circle.setAttribute("r", 2);
        circle.setAttribute("fill", this.color);
        return circle;
    }
    createLine(x1, y1, x2, y2) {
        let line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", x1);
        line.setAttribute("y1", y1);
        line.setAttribute("x2", x2);
        line.setAttribute("y2", y2);
        line.setAttribute("stroke", this.color);
        return line;
    }
};