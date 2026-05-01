#!/bin/bash

# Fix 1: Better card hover animation - stronger lift/pop
cat >> src/components/Projects.css << 'EOF'

/* Enhanced card pop animation */
.project-card {
  will-change: transform;
}

.project-card:hover {
  transform: translateY(-12px) scale(1.03) !important;
  box-shadow: 0 24px 60px rgba(124, 106, 255, 0.3), 0 0 0 1px rgba(124, 106, 255, 0.4) !important;
  z-index: 2;
}
EOF

# Fix 2: Restrict easter egg to ONLY the logo button click, not the whole navbar
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect } from 'react';
import EasterEgg from './EasterEgg';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'about',      href: '#about' },
  { label: 'experience', href: '#experience' },
  { label: 'skills',     href: '#skills' },
  { label: 'projects',   href: '#projects' },
  { label: 'contact',    href: '#contact' },
];

function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [active, setActive] = useState('');
  const [eggTrigger, setEggTrigger] = useState(0);
  const [showHint, setShowHint] = useState(false);

  useEffect(() => {
    const onScroll = () => {
      setScrolled(window.scrollY > 40);
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

  const handleNavClick = (href, e) => {
    e.stopPropagation();
    setMenuOpen(false);
    setActive(href);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  const handleLogoClick = (e) => {
    e.stopPropagation();
    setEggTrigger(prev => prev + 1);
    setShowHint(true);
    setTimeout(() => setShowHint(false), 1500);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <>
      <EasterEgg trigger={eggTrigger} />
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
        <div className="container navbar__inner">
          <button className="navbar__logo" onClick={handleLogoClick} title="✨ try clicking me">
            Zoheb Khan
            {showHint && <span className="navbar__egg-hint">🚀</span>}
          </button>
          <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
            {NAV_LINKS.map(link => (
              <button key={link.href}
                className={`navbar__link ${active === link.href ? 'navbar__link--active' : ''}`}
                onClick={(e) => handleNavClick(link.href, e)}>
                {link.label}
              </button>
            ))}
            <a href="/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="navbar__resume">
              resume ↓
            </a>
          </nav>
          <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
            onClick={(e) => { e.stopPropagation(); setMenuOpen(!menuOpen); }}
            aria-label="Toggle menu">
            <span /><span /><span />
          </button>
        </div>
      </header>
    </>
  );
}
export default Navbar;
EOF

# Add hint style to Navbar.css
cat >> src/components/Navbar.css << 'EOF'

.navbar__egg-hint {
  position: absolute;
  top: -20px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 1.2rem;
  animation: floatUp 1.5s ease forwards;
  pointer-events: none;
}

@keyframes floatUp {
  0%   { opacity: 1; transform: translateX(-50%) translateY(0); }
  100% { opacity: 0; transform: translateX(-50%) translateY(-30px); }
}
EOF

echo "✅ Fixed! Cards now pop strongly, easter egg only triggers on name click!"
