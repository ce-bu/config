class !name!
{
public:
    !name!(int value) : _value(value) { std::cout << __FUNCSIG__ << std::endl; }
    !name!(const !name!& o ) { std::cout << __FUNCSIG__ << std::endl; _value = o._value; }
    !name!(!name!&& o) noexcept { std::cout << __FUNCSIG__ << std::endl; _value = o._value; o._value = 0; }
    !name!& operator=(const !name!& o) { std::cout << __FUNCSIG__ << std::endl; _value = o._value; return *this; }
    !name!& operator=(!name!&& o) noexcept { std::cout << __FUNCSIG__ << std::endl; _value = o._value; o._value = 0; return *this; }
    ~!name!() noexcept { std::cout << __FUNCSIG__ << " value=" << value << std::endl; }
private:
    int _value{};
};

