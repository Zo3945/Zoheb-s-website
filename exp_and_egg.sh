#!/bin/bash

# Fix experience cards to glow and pop
cat >> src/components/Experience.css << 'EOF'

.exp-card {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease, border-color 0.3s ease;
  will-change: transform;
}

.exp-card:hover {
  transform: translateY(-10px) scale(1.02);
  box-shadow: 0 20px 60px rgba(124, 106, 255, 0.25), 0 0 0 1px rgba(124, 106, 255, 0.4);
  border-color: rgba(124, 106, 255, 0.5);
}

.exp-card:hover .exp-card__company {
  color: var(--accent);
  transition: color 0.2s ease;
}
EOF

# Update Navbar - 3 clicks for easter egg
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
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
  const [scrolled, setScrolled]     = useState(false);
  const [menuOpen, setMenuOpen]     = useState(false);
  const [active, setActive]         = useState('');
  const [eggTrigger, setEggTrigger] = useState(0);
  const [clicks, setClicks]         = useState(0);
  const [hint, setHint]             = useState('');
  const timerRef                    = useRef(null);

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

  const handleLogoClick = (e) => {
    e.stopPropagation();
    window.scrollTo({ top: 0, behavior: 'smooth' });

    const newClicks = clicks + 1;
    setClicks(newClicks);

    clearTimeout(timerRef.current);

    if (newClicks === 1) {
      setHint('2 more...');
    } else if (newClicks === 2) {
      setHint('1 more...');
    } else if (newClicks >= 3) {
      setEggTrigger(prev => prev + 1);
      setHint('🚀💥');
      setClicks(0);
    }

    timerRef.current = setTimeout(() => {
      setClicks(0);
      setHint('');
    }, 2000);
  };

  const handleNavClick = (href, e) => {
    e.stopPropagation();
    setMenuOpen(false);
    setActive(href);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <>
      <EasterEgg trigger={eggTrigger} />
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
        <div className="container navbar__inner">
          <button className="navbar__logo" onClick={handleLogoClick} title="psst... try clicking 3 times">
            Zoheb Khan
            {hint && <span className="navbar__egg-hint">{hint}</span>}
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

echo "✅ Experience cards now glow and pop, easter egg requires 3 clicks!"
