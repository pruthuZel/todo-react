import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],

  // Base path should be root for custom domain deployments
  base: '/',

  preview: {
    host: true,            // bind to 0.0.0.0
    port: 8080,            // server port
    allowedHosts: [
      'demo.condense.zeliot.in'
    ]
  }
})
