#include "BackendBinding.hpp"

#include "../internal.hpp"

#include <SDL_vulkan.h>
#include <dawn/native/OpenVRBackend.h>

namespace aurora::webgpu::utils {
static Module Log("aurora::webgpu::utils::OpenVRBinding");

class OpenVRBinding : public BackendBinding {
public:
  OpenVRBinding(SDL_Window* window, WGPUDevice device) : BackendBinding(window, device) {}

  uint64_t GetSwapChainImplementation() override {
    if (m_swapChainImpl.userData == nullptr) {
      CreateSwapChainImpl();
    }
    return reinterpret_cast<uint64_t>(&m_swapChainImpl);
  }

  WGPUTextureFormat GetPreferredSwapChainTextureFormat() override {
    if (m_swapChainImpl.userData == nullptr) {
      CreateSwapChainImpl();
    }
    return dawn::native::openvr::GetNativeSwapChainPreferredFormat(&m_swapChainImpl);
  }

private:
  DawnSwapChainImplementation m_swapChainImpl{};

  void CreateSwapChainImpl() {
    VkSurfaceKHR surface = VK_NULL_HANDLE;
    ASSERT(SDL_Vulkan_CreateSurface(m_window, dawn::native::openvr::GetInstance(m_device), &surface),
           "Failed to create Vulkan surface: {}", SDL_GetError());
    m_swapChainImpl = dawn::native::openvr::CreateNativeSwapChainImpl(m_device, surface);
  }
};

BackendBinding* CreateOpenVRBinding(SDL_Window* window, WGPUDevice device) { return new OpenVRBinding(window, device); }
} // namespace aurora::webgpu::utils
