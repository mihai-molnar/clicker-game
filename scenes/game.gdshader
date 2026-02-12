shader_type canvas_item;

  uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

  // Tuneable parameters
  uniform float scanline_strength : hint_range(0.0, 1.0) = 0.3;
  uniform float scanline_frequency : hint_range(100.0, 800.0) = 300.0;
  uniform float curvature : hint_range(0.0, 10.0) = 5.0;
  uniform float vignette_strength : hint_range(0.0, 1.0) = 0.4;
  uniform float aberration : hint_range(0.0, 5.0) = 1.0;
  uniform float brightness : hint_range(0.8, 1.5) = 1.1;
  uniform float noise_strength : hint_range(0.0, 0.1) = 0.03;
  uniform float jitter_strength : hint_range(0.0, 0.01) = 0.002;
  uniform float jitter_speed : hint_range(1.0, 50.0) = 15.0;

  vec2 curve(vec2 uv) {
      uv = uv * 2.0 - 1.0;
      vec2 offset = abs(uv.yx) / vec2(curvature);
      uv = uv + uv * offset * offset;
      uv = uv * 0.5 + 0.5;
      return uv;
  }

  float random(vec2 uv) {
      return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
  }

  void fragment() {
      // VHS-style screen jitter
      vec2 jitter = vec2(
          random(vec2(TIME * jitter_speed, 0.0)) - 0.5,
          random(vec2(0.0, TIME * jitter_speed)) - 0.5
      ) * jitter_strength;

      vec2 uv = curve(SCREEN_UV + jitter);

      // Black outside curved screen area
      if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
          COLOR = vec4(0.0, 0.0, 0.0, 1.0);
      } else {
          // Chromatic aberration
          vec2 pixel_size = SCREEN_PIXEL_SIZE * aberration;
          float r = texture(screen_texture, uv + vec2(pixel_size.x, 0.0)).r;
          float g = texture(screen_texture, uv).g;
          float b = texture(screen_texture, uv - vec2(pixel_size.x, 0.0)).b;
          vec3 col = vec3(r, g, b);

          // Scanlines
          float scanline = sin(uv.y * scanline_frequency * PI) * 0.5 + 0.5;
          col *= 1.0 - scanline_strength * (1.0 - scanline);

          // Vignette
          float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
          vignette = clamp(pow(16.0 * vignette, vignette_strength), 0.0, 1.0);
          col *= vignette;

          // Noise
          float noise = random(uv + mod(TIME, 100.0)) * noise_strength;
          col += noise;

          // Brightness boost to compensate for darkening
          col *= brightness;

          COLOR = vec4(col, 1.0);
      }
  }