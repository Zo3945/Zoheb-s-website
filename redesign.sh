#!/bin/bash

# Update background and CSS variables to match the HTML mockup
python3 << 'EOF'
with open('src/styles/App.css', 'r') as f:
    content = f.read()

# Update background colors to match mockup
content = content.replace('--bg-primary: #0a0a0f', '--bg-primary: #04060d')
content = content.replace('--bg-secondary: #111118', '--bg-secondary: #0a0c18')
content = content.replace('--bg-card: #16161f', '--bg-card: #0f1424')

with open('src/styles/App.css', 'w') as f:
    f.write(content)
print('App.css updated!')
EOF

# Update Navbar to match mockup exactly
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import EasterEgg from './EasterEgg';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'About',      href: '#about' },
  { label: 'Experience', href: '#experience' },
  { label: 'Skills',     href: '#skills' },
  { label: 'Projects',   href: '#projects' },
  { label: 'Repos',      href: '#github-repos' },
  { label: 'Contact',    href: '#contact' },
];

function Navbar({ onSearch }) {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [active, setActive] = useState('');
  const [eggTrigger, setEggTrigger] = useState(0);
  const [clicks, setClicks] = useState(0);
  const [searchOpen, setSearchOpen] = useState(false);
  const [query, setQuery] = useState('');
  const timerRef = useRef(null);
  const searchRef = useRef(null);
  const isScrollingRef = useRef(false);

  useEffect(() => {
    const onScroll = () => {
      setScrolled(window.scrollY > 40);
      if (isScrollingRef.current) return;
      const windowHeight = window.innerHeight;
      const docHeight = document.documentElement.scrollHeight;
      if (window.scrollY + windowHeight >= docHeight - 50) {
        setActive('#contact');
        return;
      }
      const sections = NAV_LINKS.map(l => l.href.replace('#', ''));
      for (let i = sections.length - 1; i >= 0; i--) {
        const el = document.getElementById(sections[i]);
        if (el && window.scrollY >= el.offsetTop - 120) {
          setActive('#' + sections[i]);
          break;
        }
      }
    };
    window.addEventListener('scroll', onScroll);
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  useEffect(() => {
    if (searchOpen && searchRef.current) {
      setTimeout(() => searchRef.current?.focus(), 50);
    }
  }, [searchOpen]);

  const handleLogoClick = () => {
    const newClicks = clicks + 1;
    setClicks(newClicks);
    clearTimeout(timerRef.current);
    if (newClicks >= 3) {
      setEggTrigger(prev => prev + 1);
      setClicks(0);
    } else {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    timerRef.current = setTimeout(() => setClicks(0), 2000);
  };

  const handleNavClick = (href) => {
    setMenuOpen(false);
    setActive(href);
    isScrollingRef.current = true;
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
    setTimeout(() => { isScrollingRef.current = false; }, 1000);
  };

  const handleSearchChange = (e) => {
    const val = e.target.value;
    setQuery(val);
    if (onSearch) onSearch(val);
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      const first = document.querySelector('.search-highlight');
      if (first) first.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    if (e.key === 'Escape') {
      setQuery('');
      if (onSearch) onSearch('');
      setSearchOpen(false);
    }
  };

  return (
    <>
      <EasterEgg trigger={eggTrigger} />
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
        <div className="container navbar__inner">

          <button className="navbar__logo" onClick={handleLogoClick}>
            Zoheb Khan
          </button>

          <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
            {NAV_LINKS.map(link => (
              <button key={link.href}
                className={`navbar__link ${active === link.href ? 'navbar__link--active' : ''}`}
                onClick={() => handleNavClick(link.href)}>
                {link.label}
              </button>
            ))}
          </nav>

          <div className="navbar__right">
            <a href="/Zoheb-s-website/resume.pdf"
              download="Zoheb_Khan_Resume.pdf"
              className="navbar__resume">
              Resume ↓
            </a>

            <div className="navbar__search-area">
              {searchOpen ? (
                <div className="navbar__search-container">
                  <input
                    ref={searchRef}
                    type="text"
                    className="navbar__search-input"
                    placeholder="Search..."
                    value={query}
                    onChange={handleSearchChange}
                    onKeyDown={handleKeyDown}
                  />
                  <button className="navbar__search-clear" onClick={() => {
                    setQuery('');
                    if (onSearch) onSearch('');
                    setSearchOpen(false);
                  }}>✕</button>
                </div>
              ) : (
                <button className="navbar__search-btn" onClick={() => setSearchOpen(true)}>
                  <svg width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                  </svg>
                </button>
              )}
            </div>
          </div>

          <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
            onClick={() => setMenuOpen(!menuOpen)}>
            <span /><span /><span />
          </button>

        </div>
      </header>
    </>
  );
}
export default Navbar;
EOF

# Update Navbar CSS to match mockup
python3 << 'EOF'
with open('src/components/Navbar.css', 'r') as f:
    content = f.read()

# Add navbar__right styles and fix search area
extra = """
.navbar__right {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-left: auto;
}

.navbar__search-btn {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: none;
  border: none;
  cursor: pointer;
  color: rgba(200,200,220,0.5);
  transition: color var(--transition);
  padding: 0;
}

.navbar__search-btn:hover {
  color: var(--text-primary);
}
"""

content += extra

with open('src/components/Navbar.css', 'w') as f:
    f.write(content)
print('Navbar.css updated!')
EOF

echo "✅ Redesign applied!"
