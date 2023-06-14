
// clang-format off
class !name!
{
public:
    !name!() { std::cout << __PRETTY_FUNCTION__ << std::endl; }
    !name!(const !name!&) { std::cout << __PRETTY_FUNCTION__ << std::endl; }
    !name!(!name!&&) noexcept { std::cout << __PRETTY_FUNCTION__ << std::endl; }
    !name!& operator=(const !name!&) { std::cout << __PRETTY_FUNCTION__ << std::endl; return *this; }
    !name!& operator=(!name!&&) noexcept { std::cout << __PRETTY_FUNCTION__ << std::endl; return *this; }
    ~!name!() noexcept { std::cout << __PRETTY_FUNCTION__ << std::endl; }    
};
// clang-format on
