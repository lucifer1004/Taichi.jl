using Taichi

let
    ti.init()
    n = 512
    x = ti.field(; dtype=ti.f32, shape=(n, n))

    taichi_logo = @ti_func (pos, scale=1 / 1.11) -> begin
        p = (pos - 0.5) / scale + 0.5
        ret = -1
        if (p - 0.50).norm_sqr() > 0.52^2
            ret = 1
        elseif (p - 0.50).norm_sqr() > 0.495^2
            ret = 0
        elseif (p - ti.Vector([0.50, 0.25])).norm_sqr() <= 0.08^2
            ret = 0
        elseif (p - ti.Vector([0.50, 0.75])).norm_sqr() <= 0.08^2
            ret = 1
        elseif (p - ti.Vector([0.50, 0.25])).norm_sqr() <= 0.25^2
            ret = 1
        elseif (p - ti.Vector([0.50, 0.75])).norm_sqr() <= 0.25^2
            ret = 0
        elseif p[0] < 0.5
            ret = 0
        else
            ret = 1
        end
        return ret
    end

    paint = @ti_kernel () -> begin
        for (i, j) in ti.ndrange(n * 4, n * 4)
            ret = taichi_logo(ti.Vector([i, j]) / (n * 4))
            x[i ÷ 4, j ÷ 4] += ret / 16
        end
    end

    paint()
    gui = ti.GUI("Logo", (n, n))
    while pytruth(gui.running)
        gui.set_image(x)
        gui.show()
    end
end
