using Taichi

let
    ti.init(; arch=ti.gpu)
    n = 640
    pixels = ti.Vector.field(3; dtype=pytype(1.0), shape=(n * 2, n))
    locals = map(x -> string(x.first) => x.second, collect(Base.@locals))

    paint = Taichi.@ti_kernel(function f(t::Float64)
                                  for (i, j) in pixels
                                      c = ti.Vector([-0.8, ti.cos(t) * 0.2])
                                      z = ti.Vector([i / n - 1, j / n - 0.5]) * 2
                                      rgb = ti.Vector([0, 1, 1])
                                      iterations = 0
                                      while z.norm() < 20 && iterations < 50
                                          z = ti.Vector([z[0]^2 - z[1]^2, z[0] * z[1] * 2]) + c
                                          iterations += 1
                                          pixels[i, j] = (1 - iterations * 0.02) * rgb
                                      end
                                  end
                              end, locals)

    gui = ti.GUI("Julia Set"; res=(n * 2, n))

    # Comment out the vm related code to export .gif file
    # vm = ti.tools.VideoManager(; output_dir="./gif", framerate=24, automatic_build=false)
    i = 0
    flag = 0
    while pytruth(gui.running)
        if flag == 0
            i -= 1
            if i * 0.02 <= 0.2
                flag = 1
            end
        else
            i += 1
            if i * 0.02 > (π * 1.2)
                flag = 0
            end
        end

        paint(i * 0.02)
        gui.set_image(pixels)
        # vm.write_frame(pixels)
        gui.show()
    end

    # vm.make_video(false, true)
end
