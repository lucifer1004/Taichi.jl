using Taichi

let
    ti.init(; arch=ti.gpu)
    n = 64
    cell_size = 8
    img_size = n * cell_size
    alive = ti.field(pytype(1); shape=(n, n))  # alive = 1, dead = 0
    count = ti.field(pytype(1); shape=(n, n))  # count of neighbours
    B, S = PyList([3]), PyList([2, 3])
    locals = map(x -> string(x.first) => x.second, collect(Base.@locals))

    get_count = Taichi.@ti_func(function f(i, j)
                                    return (alive[i - 1, j] + alive[i + 1, j] + alive[i, j - 1] +
                                            alive[i, j + 1] + alive[i - 1, j - 1] + alive[i + 1, j - 1] +
                                            alive[i - 1, j + 1] + alive[i + 1, j + 1])
                                end, locals)


    calc_rule = Taichi.@ti_func(function f(a, c)
                                    if a == 0
                                        for t in ti.static(B)
                                            if c == t
                                                a = 1
                                            end
                                        end
                                    elseif a == 1
                                        a = 0
                                        for t in ti.static(S)
                                            if c == t
                                                a = 1
                                            end
                                        end
                                    end
                                    return a
                                end, locals)


    locals = map(x -> string(x.first) => x.second, collect(Base.@locals))
    run = Taichi.@ti_kernel(function f()
                                for (i, j) in alive
                                    count[i, j] = get_count(i, j)
                                end

                                for (i, j) in alive
                                    alive[i, j] = calc_rule(alive[i, j], count[i, j])
                                end
                            end, locals)


    init = Taichi.@ti_kernel(function f()
                                 for (i, j) in alive
                                     if ti.random() > 0.8
                                         alive[i, j] = 1
                                     else
                                         alive[i, j] = 0
                                     end
                                 end
                             end, locals)


    gui = ti.GUI("Game of Life", (img_size, img_size))
    gui.fps_limit = 15

    println("[Hint] Press `r` to reset")
    println("[Hint] Press SPACE to pause")
    println("[Hint] Click LMB, RMB and drag to add alive / dead cells")

    init()
    paused = false
    while pytruth(gui.running)
        for e in gui.get_events(gui.PRESS, gui.MOTION)
            if pyeq(Bool, e.key, gui.ESCAPE)
                gui.running = false
            elseif pyeq(Bool, e.key, gui.SPACE)
                paused = !paused
            elseif pyeq(Bool, e.key, 'r')
                alive.fill(0)
            end
        end

        if pytruth(gui.is_pressed(gui.LMB, gui.RMB))
            mx, my = gui.get_cursor_pos()
            alive[pyint(mx * n), pyint(my * n)] = gui.is_pressed(gui.LMB)
            paused = true
        end

        if !paused
            run()
        end

        gui.set_image(ti.tools.imresize(alive, img_size).astype(np.uint8) * 255)
        gui.show()
    end
end